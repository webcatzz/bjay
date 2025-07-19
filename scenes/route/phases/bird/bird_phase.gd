extends Phase


func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	bird_arrow(Route.along(1, 0.25), 6, Vector2(24.0, 16.0), 64.0)
	await get_tree().create_timer(2.0).timeout
	await bird_arrow(Route.along(1, 0.75), 6, Vector2(24.0, 16.0), 48.0)
	await bird_flurry(Route.along(1, 0.5))
	await get_tree().create_timer(1.0).timeout
	end()


func bird(y: float, speed: float) -> void:
	var node := preload("res://scenes/route/phases/bird/bird.tscn").instantiate()
	node.position.y = y
	add_child(node)
	Route.guide(node, preload("res://assets/right_to_left_path.tres"), speed)


func bird_arrow(y: float, depth: int, spacing: Vector2, speed: float) -> void:
	spacing.x /= speed
	bird(y, speed)
	for i: int in range(1, depth):
		await get_tree().create_timer(spacing.x).timeout
		bird(y - i * spacing.y, speed)
		bird(y + i * spacing.y, speed)


func bird_flurry(y: float) -> void:
	for i: int in 8:
		await bird_arrow(y, 2, Vector2(16.0, 10.0), 256.0)
		await get_tree().create_timer(0.1).timeout
