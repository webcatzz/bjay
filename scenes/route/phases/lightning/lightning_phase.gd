extends Phase


func _ready() -> void:
	populate_clouds()
	for i: int in 10:
		strike_at(Route.randv(), randf_range(0.0, PI))
		await get_tree().create_timer(lerp(1.0, 0.5, minf(i / 4.0, 1.0))).timeout
	await sweep(0, Route.RECT.position.x, Route.along(0, 0.75))
	await get_tree().create_timer(1.0).timeout
	await sweep(0, Route.RECT.end.x, Route.along(0, 0.25))
	await get_tree().create_timer(1.0).timeout
	end()


func strike(start: Vector2, end: Vector2, attack_delay: float = 0.0) -> void:
	var node := preload("res://scenes/route/phases/lightning/lightning.tscn").instantiate()
	node.position = start
	node.end = end
	node.attack_delay = attack_delay
	add_child(node)


func strike_at(point: Vector2, angle: float, attack_delay: float = 0.0) -> void:
	strike(Route.edge(angle, point), Route.edge(angle + PI, point), attack_delay)


func sweep(axis: int, start: float, end: float, spacing: float = 20.0) -> void:
	var strike_count: int = abs((end - start) / spacing) + 1
	spacing *= signi(end - start)
	for i: int in strike_count:
		var from: Vector2 = Route.RECT.position
		from[axis] = start + spacing * i
		var to: Vector2 = Route.RECT.end
		to[axis] = from[axis]
		strike(from, to, 0.075 * (strike_count - i))
		await get_tree().create_timer(0.075).timeout


func populate_clouds() -> void:
	var path: Path2D = $CloudPath
	for i: int in 64:
		var node := preload("res://scenes/route/parts/loop_cloud.tscn").instantiate()
		node.modulate = Color("#190322", randf_range(0.75, 1.0))
		node.radius = randf_range(16.0, 32.0)
		node.speed = randf_range(48.0, 80.0)
		node.v_offset = Route.randf_along(1, node.radius)
		path.add_child(node)
		node.progress_ratio = randf()
