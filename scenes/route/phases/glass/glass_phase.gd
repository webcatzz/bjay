extends Phase

@onready var noise: FastNoiseLite = $Background/Noise.texture.noise


func _ready() -> void:
	populate_shards()


func populate_shards() -> void:
	var path: Path2D = $Path
	for i: int in 32:
		var node := preload("res://scenes/route/phases/glass/shard.tscn").instantiate()
		var follower := PathFollower.new()
		follower.rotates = false
		follower.cubic_interp = false
		follower.speed = randf_range(28.0, 36.0)
		follower.add_child(node)
		path.add_child(follower)
		while true:
			follower.v_offset = Route.randf_along(1)
			follower.progress_ratio = randf()
			if node.global_position.distance_squared_to(route.player.global_position) > 1024.0:
				break


func _physics_process(delta: float) -> void:
	noise.offset.x += 4.0 * delta
