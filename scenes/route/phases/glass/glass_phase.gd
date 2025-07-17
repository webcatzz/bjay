extends Phase


func _ready() -> void:
	populate_clouds()
	populate_shards()


func populate_clouds() -> void:
	var path: Path2D = $Path
	for i: int in 64:
		var node := preload("res://scenes/route/parts/loop_cloud.tscn").instantiate()
		node.modulate = Color("#7dae7d", randf_range(0.75, 1.0))
		node.radius = randf_range(16.0, 32.0)
		node.speed = randf_range(28.0, 36.0)
		node.v_offset = Route.randf_along(1, node.radius)
		node.z_index = -1
		path.add_child(node)
		node.progress_ratio = randf()


func populate_shards() -> void:
	var path: Path2D = $Path
	
	for i: int in 32:
		var node := preload("res://scenes/route/phases/glass/shard.tscn").instantiate()
		var follower := PathFollower.new()
		follower.rotates = false
		follower.cubic_interp = false
		follower.speed = randf_range(28.0, 36.0)
		follower.v_offset = Route.randf_along(1)
		follower.add_child(node)
		path.add_child(follower)
		follower.progress_ratio = randf()
