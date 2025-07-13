extends Phase

const Lightning := preload("res://scenes/route/phases/lightning/lightning.gd")


func _ready() -> void:
	populate_clouds()
	await get_tree().create_timer(1.0).timeout
	# lines
	for i: int in 6:
		lightning_ray(Route.randv(), randf_range(0.0, TAU))
		await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
	# crosses
	for i: int in 6:
		var point: Vector2 = Route.randv()
		lightning_ray(point, randf_range(PI * -0.125, PI * 0.125))
		lightning_ray(point, randf_range(PI * 0.375, PI * 0.625))
		await get_tree().create_timer(1.0).timeout
	# spiral
	await lightning_sweep(0, 0.0, 0.5)
	await get_tree().create_timer(0.25).timeout
	await lightning_sweep(0, 1.0, 0.5)
	await get_tree().create_timer(2.0).timeout
	wipe_to_night()


func lightning(start: Vector2, end: Vector2, attack_delay: float = 0.0) -> Lightning:
	var node := preload("res://scenes/route/phases/lightning/lightning.tscn").instantiate()
	node.position = start
	node.end = end
	node.attack_delay = attack_delay
	add_child(node)
	return node


func lightning_axis(axis: int, pos: float, attack_delay: float = 0.0) -> void:
	var alt_axis: int = (axis + 1) % 2
	var start_point: Vector2 = Route.RECT.position
	start_point[axis] = pos
	var end_point: Vector2 = start_point
	end_point[alt_axis] = Route.RECT.end[alt_axis]
	lightning(start_point, end_point, attack_delay)


func lightning_ray(point: Vector2, angle: float) -> void:
	lightning(Route.edge(angle, point), Route.edge(angle + PI, point))


func lightning_sweep(axis: int, start: float, end: float, strike_num: int = 8) -> void:
	var alt_axis: int = (axis + 1) % 2
	var strike_delay: float = 0.075
	var telegraph_duration: float = (strike_num + 2) * strike_delay
	for i: int in strike_num:
		var percent: float = (i + 1) / float(strike_num + 1)
		lightning_axis(axis, lerpf(Route.RECT.position[axis], Route.RECT.end[axis], lerpf(start, end, percent)), 1.0 + telegraph_duration * (1.0 - percent))
		await get_tree().create_timer(strike_delay).timeout


func lightning_spiral(point: Vector2 = Route.RECT.get_center(), cycles: int = 1) -> void:
	var start_angle: float = PI * -0.5
	var strike_num: int = 32
	var strike_delay: float = 0.1
	for i: int in (strike_num - 1) * cycles + 1:
		var angle: float = start_angle + PI * i / (strike_num - 1)
		lightning(Route.edge(angle, point), Route.edge(angle + PI, point))
		await get_tree().create_timer(strike_delay).timeout


func lightning_tunnel(cycles: int = 1) -> void:
	var strike_num: int = 64
	var strike_delay: float = 0.2
	var extent: float = 32.0
	for i: int in strike_num * cycles:
		var wave: float = sin(i * 0.1) * 0.375 + 0.5
		var y: float = lerpf(Route.RECT.position.y, Route.RECT.end.y, wave)
		lightning_axis(1, y - extent)
		lightning_axis(1, y + extent)
		if i % 16 == 15: lightning_axis(0, Route.randf_along(0))
		await get_tree().create_timer(strike_delay).timeout


func populate_clouds() -> void:
	var clouds: Path2D = $Clouds
	
	for i: int in 64:
		var node := preload("res://scenes/route/parts/loop_cloud.tscn").instantiate()
		node.modulate = Color(Palette.THUNDER[1], randf_range(0.75, 1.0))
		node.radius = randf_range(16.0, 32.0)
		node.speed = randf_range(28.0, 36.0)
		node.v_offset = Route.randf_along(1, node.radius)
		node.material = preload("res://assets/vfx/dither.tres")
		clouds.add_child(node)
		node.progress_ratio = randf()
	
	for i: int in 64:
		var node := preload("res://scenes/route/parts/loop_cloud.tscn").instantiate()
		node.modulate = Color(Palette.THUNDER[0].blend(Color(Palette.THUNDER[1], 0.5)), randf_range(0.0, 0.5))
		node.radius = randf_range(8.0, 16.0)
		node.speed = randf_range(14.0, 18.0)
		node.v_offset = Route.randf_along(1, node.radius)
		node.material = preload("res://assets/vfx/dither.tres")
		node.z_index = -1
		clouds.add_child(node)
		node.progress_ratio = randf()
