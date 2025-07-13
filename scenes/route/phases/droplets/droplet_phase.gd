extends Phase


func _ready() -> void:
	populate_clouds()
	await droplet_rain(64, 0.15)
	droplet_rain(40, 0.25)
	await form_big_droplet(Route.RECT.get_center(), 24, 0.33)
	droplet(Route.RECT.position.x + Route.RECT.size.x * 0.5, PI * 0.5)
	await get_tree().create_timer(0.5).timeout
	droplet_rain(64, 0.25)
	await big_droplet_rain(4, 4.0)
	wipe_to_night()


func droplet(x: float, angle: float) -> void:
	var node := preload("res://scenes/route/phases/droplets/droplet.tscn").instantiate()
	var from := Vector2(x, 0.0)
	var curve := Curve2D.new()
	curve.add_point(from)
	curve.add_point(Route.edge(angle, from))
	node.follow_path(curve, randf_range(64.0, 128.0))
	add_child(node)


func big_droplet(x: float) -> void:
	var node := preload("res://scenes/route/phases/droplets/droplet_big.tscn").instantiate()
	var curve := Curve2D.new()
	curve.add_point(Vector2(x, 0.0))
	curve.add_point(Vector2(x, Route.RECT.end.y))
	node.follow_path(curve, 32.0)
	add_child(node)


func droplet_rain(droplet_count: int, delay: float) -> void:
	for i: int in droplet_count:
		droplet(Route.randf_along(0), randf_range(PI * 0.4, PI * 0.6))
		await get_tree().create_timer(delay).timeout


func big_droplet_rain(droplet_count: int, delay: float) -> void:
	for i: int in droplet_count:
		big_droplet(Route.randf_along(0))
		await get_tree().create_timer(delay).timeout


func droplet_spiral(point: Vector2, droplet_count: int, delay: float) -> void:
	for i: int in droplet_count:
		var node := preload("res://scenes/route/phases/droplets/droplet.tscn").instantiate()
		var vector: Vector2 = Vector2.from_angle(randf_range(0.0, TAU)) * 120.0
		var curve := Curve2D.new()
		curve.add_point(point + vector)
		curve.add_point(point, vector.orthogonal() * 0.5)
		node.follow_path(curve, 32.0)
		add_child(node)
		await get_tree().create_timer(delay).timeout


func form_big_droplet(point: Vector2, droplet_count: int, delay: float) -> void:
	var node := preload("res://scenes/route/phases/droplets/droplet_big.tscn").instantiate()
	node.position = point
	node.scale = Vector2.ZERO
	node.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(node)
	droplet_spiral(point, droplet_count, delay)
	var tween := create_tween()
	tween.tween_interval(4.0)
	tween.tween_property(node, ^"scale", Vector2.ONE, 8.0)
	tween.tween_interval(0.5)
	await tween.finished
	node.process_mode = Node.PROCESS_MODE_ALWAYS


func populate_clouds() -> void:
	var clouds_top: Path2D = $CloudsTop
	var clouds_bottom: Path2D = $CloudsBottom
	
	for i: int in 16:
		var node := preload("res://scenes/route/parts/loop_cloud.tscn").instantiate()
		node.modulate = Palette.RAIN_CLOUD_FORE
		node.radius = randi_range(16.0, 32.0)
		node.speed = 64.0
		node.h_offset = randf_range(-8.0, 8.0)
		node.z_index = 1
		clouds_top.add_child(node)
		node.progress_ratio = i / 16.0
	
	for i: int in 16:
		var node := preload("res://scenes/route/parts/loop_cloud.tscn").instantiate()
		node.modulate = Palette.RAIN_CLOUD_BACK
		node.radius = randi_range(12.0, 24.0)
		node.speed = 32.0
		node.h_offset = randf_range(-4.0, 4.0)
		node.v_offset = 16.0
		node.z_index = -1
		clouds_top.add_child(node)
		node.progress_ratio = i / 16.0
	
	for i: int in 16:
		var node := preload("res://scenes/route/parts/loop_cloud.tscn").instantiate()
		node.modulate = Palette.RAIN_CLOUD_BACK
		node.radius = randi_range(12.0, 24.0)
		node.speed = 32.0
		node.h_offset = randf_range(-4.0, 4.0)
		node.z_index = -1
		clouds_bottom.add_child(node)
		node.progress_ratio = i / 16.0
