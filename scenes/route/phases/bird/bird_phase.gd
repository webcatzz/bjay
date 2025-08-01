extends Phase


func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	bird_arrow(Route.along(1, 0.25), 6, Vector2(24.0, 16.0), 64.0)
	await get_tree().create_timer(2.0).timeout
	await bird_arrow(Route.along(1, 0.75), 6, Vector2(24.0, 16.0), 48.0)
	await bird_flurry(Route.along(1, 0.5))
	await get_tree().create_timer(1.0).timeout
	bird_teeth(1, 8)
	await get_tree().create_timer(3.0).timeout
	bird_teeth(0, 8)
	await get_tree().create_timer(3.0).timeout
	end()


func bird(y: float) -> Node2D:
	var node := preload("res://scenes/route/phases/bird/bird.tscn").instantiate()
	node.position.y = y
	add_child(node)
	return node


func bird_arrow(y: float, depth: int, spacing: Vector2, speed: float) -> void:
	spacing.x /= speed
	Route.guide(bird(y), preload("res://assets/paths/right_to_left.tres"), speed)
	for i: int in range(1, depth):
		await get_tree().create_timer(spacing.x).timeout
		Route.guide(bird(y - i * spacing.y), preload("res://assets/paths/right_to_left.tres"), speed)
		Route.guide(bird(y + i * spacing.y), preload("res://assets/paths/right_to_left.tres"), speed)


func bird_flurry(y: float) -> void:
	for i: int in 8:
		await bird_arrow(y, 2, Vector2(16.0, 10.0), 256.0)
		await get_tree().create_timer(0.1).timeout


func bird_teeth(axis: int, num: int) -> void:
	var alt_axis: int = (axis + 1) % 2
	var spacing: float = Route.RECT.size[axis] / (num - 1)
	for i: int in num:
		var node := preload("res://scenes/route/phases/bird/bird.tscn").instantiate()
		var start_point: Vector2
		start_point[axis] = i * spacing
		var end_point: Vector2 = start_point
		end_point[alt_axis] = Route.RECT.end[alt_axis]
		var curve := Curve2D.new()
		if i % 2:
			curve.add_point(start_point)
			curve.add_point(end_point)
		else:
			curve.add_point(end_point)
			curve.add_point(start_point)
		add_child(node)
		Route.guide(node, curve, 64.0)
