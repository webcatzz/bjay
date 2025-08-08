class_name Route
extends Node

const Player = preload("res://scenes/route/parts/player.gd")
const Wipe = preload("res://scenes/ui/wipe.gd")

const RECT := Rect2(0.0, 0.0, 192.0, 144.0)

@export var first_phase: PackedScene = preload("res://scenes/route/phases/night/night_phase.tscn")

var phase: Phase
var next_phase: Phase

@onready var player: Player = $Player
@onready var music: AudioStreamPlayer = $Music


func _ready() -> void:
	phase = first_phase.instantiate()
	await get_tree().create_timer(0.5).timeout
	add_child(phase)
	await Game.wipe.wipe_out()
	player.z_index = 0


func step(branch: int = 0 if Game.place.next_places.size() == 1 else -1) -> void:
	# branch selection
	if branch == -1:
		next_phase = preload("res://scenes/route/phases/night/night_phase.tscn").instantiate()
	else:
		Game.place = Game.place.next_places[branch]
		# delivering mail
		var idx: int = 0
		while idx < Game.inventory.size():
			if Game.inventory[idx].destination == Game.place:
				Game.deliver_item(idx)
			else:
				idx += 1
		# ending route if at destination
		if Game.place == Map.destination:
			await Game.wipe.wipe_in(Color("#5b4ecc"))
			get_tree().change_scene_to_file("res://scenes/ui/route_end/route_end.tscn")
			Game.wipe.wipe_out()
			return
		next_phase = Game.place.type.scene.instantiate()
	# wipe in
	if not phase.hide_player and not next_phase.hide_player:
		player.z_index = Game.wipe.z_index
	await Game.wipe.wipe_in(phase.wipe_color)
	# switching phases
	phase.queue_free()
	phase = next_phase
	next_phase = null
	add_child(phase)
	# wipe out
	await Game.wipe.wipe_out(phase.wipe_color)
	player.z_index = 0


# math

static func along(axis: int, value: float) -> float:
	return Route.RECT.position[axis] + Route.RECT.size[axis] * value


static func randf_along(axis: int, extents: float = 0.0) -> float:
	return randf_range(Route.RECT.position[axis] - extents, Route.RECT.end[axis] + extents)


static func randv() -> Vector2:
	return Route.RECT.position + Route.RECT.size * Vector2(randf(), randf())


static func edge(angle: float, origin: Vector2 = RECT.get_center()) -> Vector2:
	var support: Vector2 = RECT.get_support(Vector2.from_angle(angle))
	var support_offset: Vector2 = support - origin
	var support_angle: float = support_offset.angle()
	if fposmod(angle, PI * 0.5) == 0.0: # undefined tan
		return origin + Vector2.from_angle(angle) * support_offset.abs()
	elif (posmod(floori(support_angle / PI * 2.0), 4) + int(support_angle < angle)) % 2:
		return origin + Vector2(tan(PI * 0.5 - angle), 1.0) * support_offset.y
	else:
		return origin + Vector2(1.0, tan(angle)) * support_offset.x


# paths

static func guide(node: Node2D, curve: Curve2D, speed: float, rotate: bool = false) -> void:
	var tween := node.create_tween()
	tween.tween_method((sample_path_transform if rotate else sample_path_position).bind(node, curve, node.position), 0.0, curve.get_baked_length(), curve.get_baked_length() / speed)
	tween.tween_callback(node.queue_free)


static func sample_path_position(at: float, node: Node2D, curve: Curve2D, offset: Vector2) -> void:
	node.position = curve.sample_baked(at) + offset


static func sample_path_transform(at: float, node: Node2D, curve: Curve2D, offset: Vector2) -> void:
	node.transform = curve.sample_baked_with_rotation(at).translated(offset)
