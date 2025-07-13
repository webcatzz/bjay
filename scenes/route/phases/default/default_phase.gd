extends Phase


func _ready() -> void:
	populate_clouds()


func populate_clouds() -> void:
	var clouds: Path2D = $Clouds
	
	for i: int in 16:
		var node := preload("res://scenes/route/parts/loop_cloud.tscn").instantiate()
		node.modulate = Color(Palette.WHITE, randf_range(0.75, 1.0))
		node.radius = randf_range(16.0, 32.0)
		node.speed = randf_range(28.0, 36.0)
		node.v_offset = Route.randf_along(1, node.radius)
		clouds.add_child(node)
		node.progress_ratio = randf()
	
	for i: int in 32:
		var node := preload("res://scenes/route/parts/loop_cloud.tscn").instantiate()
		node.modulate = Color(Palette.BLUE.blend(Color(Palette.WHITE, 0.5)), randf_range(0.0, 0.5))
		node.radius = randf_range(8.0, 16.0)
		node.speed = randf_range(14.0, 18.0)
		node.v_offset = Route.randf_along(1, node.radius)
		node.z_index = -1
		clouds.add_child(node)
		node.progress_ratio = randf()
