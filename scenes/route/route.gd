class_name Route
extends Node

const Player = preload("res://scenes/route/parts/player.gd")
const Wipe = preload("res://scenes/ui/wipe.gd")

const RECT := Rect2(0.0, 0.0, 192.0, 144.0)

@onready var player: Player = $Player
@onready var wipe: Wipe = $Wipe


func wipe_in() -> void:
	player.z_index = wipe.z_index
	await wipe.wipe_in()


func wipe_out() -> void:
	await wipe.wipe_out()
	player.z_index = 0


func wipe_to(scene: PackedScene, from: Node = null) -> void:
	await wipe_in()
	if from: from.queue_free()
	add_child(scene.instantiate())
	wipe_out()


# ui

func _ready() -> void:
	_on_inventory_changed()
	_on_health_changed()
	Game.inventory_changed.connect(_on_inventory_changed)
	Game.health_changed.connect(_on_health_changed)
	add_child(preload("res://scenes/route/phases/night/night_phase.tscn").instantiate())
	wipe_out()


func _on_inventory_changed() -> void:
	$UI/MailCount.text = str(Game.inventory.size()) + " mail"


func _on_health_changed() -> void:
	$UI/HealthBar.value = Game.health


# math

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
