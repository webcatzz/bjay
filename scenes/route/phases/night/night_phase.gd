extends Phase

@onready var map: Node2D = $Background/Map


func _ready() -> void:
	$Background/MoonShadow/Moon/Phase.position.x = randf_range(-20.0, 0.0)


func end() -> void:
	map.set_physics_process(false)
	Game.place = Game.place.next_places[map.player_idx]
	route.wipe_to(Game.place.type.phase, self)
