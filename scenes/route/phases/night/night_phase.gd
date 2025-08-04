extends Phase

@onready var map: Node2D = $Background/Map


func _ready() -> void:
	$Background/MoonShadow/Moon/Phase.position.x = randf_range(-20.0, 0.0)
	$Music.seek(randf_range(0.0, $Music.stream.get_length()))
	var tween := create_tween().set_parallel()
	tween.tween_property($Music, ^"volume_linear", 1.0, 0.5).from(0.0)
	tween.tween_property(route.music, ^"volume_linear", 0.1, 0.5)


func end() -> void:
	map.set_physics_process(false)
	var tween := create_tween().set_parallel()
	tween.tween_property($Music, ^"volume_linear", 0.0, 1.0)
	tween.tween_property(route.music, ^"volume_linear", 1.0, 1.0)
	route.step(map.branch)
