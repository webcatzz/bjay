extends Phase

const Constellation = preload("res://scenes/route/parts/constellation.gd")

var branch: int
var branch_idxs: PackedInt32Array

@onready var constellation: Constellation = $Background/Constellation
@onready var timer_bar: TextureProgressBar = $Background/TimerBar
@onready var timer: Timer = $Timer


func _ready() -> void:
	$Background/MoonShadow/Moon/Phase.position.x = randf_range(-20.0, 0.0)
	timer_bar.max_value = timer.wait_time
	
	constellation.resize(Map.size)
	var nodes: Dictionary[Place, Node2D]
	for place: Place in Map.places():
		nodes[place] = constellation.add_node(place.coords, place.type.icon)
	
	for place: Place in Map.places():
		for next_place: Place in place.next_places:
			var idx: int = constellation.add_edge(nodes[place], nodes[next_place])
			if place == Game.place:
				constellation.set_edge_color(idx, Palette.NIGHT[2])
				branch_idxs.append(idx)
			elif next_place == Map.destination:
				constellation.set_edge_method(idx, constellation.draw_dashed_line)


func _physics_process(delta: float) -> void:
	branch = remap(route.player.position.y, Route.RECT.position.y, Route.RECT.end.y, 0.0, Game.place.next_places.size())
	for i: int in branch_idxs.size():
		constellation.set_edge_color(branch_idxs[i], Palette.NIGHT[3 if i == branch else 2])
	timer_bar.value = timer.time_left


func end() -> void:
	set_physics_process(false)
	route.step(branch)
