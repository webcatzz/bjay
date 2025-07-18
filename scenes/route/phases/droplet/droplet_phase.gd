extends Phase


func _ready() -> void:
	populate_clouds()
	await rain(64, 0.15)
	rain(40, 0.25)
	await form_droplet_mama(Route.RECT.get_center())
	droplet(Route.RECT.position.x + Route.RECT.size.x * 0.5, PI * 0.5)
	await get_tree().create_timer(0.5).timeout
	rain(64, 0.25)
	await rain_mama(4, 4.0)
	end()


func droplet(x: float, angle: float) -> void:
	var node := preload("res://scenes/route/phases/droplet/droplet.tscn").instantiate()
	var curve := Curve2D.new()
	curve.add_point(Vector2(x, Route.RECT.position.y))
	curve.add_point(Route.edge(angle, Vector2(x, Route.RECT.position.y)))
	add_child(node)
	Route.guide(node, curve, randf_range(80.0, 112.0))


func droplet_mama(x: float) -> void:
	var node := preload("res://scenes/route/phases/droplet/droplet_mama.tscn").instantiate()
	var curve := Curve2D.new()
	curve.add_point(Vector2(x, Route.RECT.position.y))
	curve.add_point(Vector2(x, Route.RECT.end.y))
	add_child(node)
	Route.guide(node, curve, 32.0)


func rain(droplet_count: int, delay: float) -> void:
	for i: int in droplet_count:
		droplet(randf_range(Route.RECT.position.x, Route.RECT.end.x), PI * randf_range(0.45, 0.55))
		await get_tree().create_timer(delay).timeout


func rain_mama(droplet_count: int, delay: float) -> void:
	for i: int in droplet_count:
		droplet_mama(randf_range(Route.RECT.position.x, Route.RECT.end.x))
		await get_tree().create_timer(delay).timeout


func droplet_spiral(point: Vector2, droplet_count: int) -> void:
	for i: int in droplet_count:
		var node := preload("res://scenes/route/phases/droplet/droplet.tscn").instantiate()
		var curve := Curve2D.new()
		var vector: Vector2 = Vector2.from_angle(randf_range(0.0, TAU)) * 120.0
		curve.add_point(point + vector)
		curve.add_point(point, vector.orthogonal() * 0.5)
		add_child(node)
		Route.guide(node, curve, 24.0)
		await get_tree().create_timer(0.5).timeout


func form_droplet_mama(point: Vector2) -> void:
	var node := preload("res://scenes/route/phases/droplet/droplet_mama.tscn").instantiate()
	node.position = point
	node.scale = Vector2.ZERO
	node.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(node)
	droplet_spiral(point, 16)
	var tween := create_tween()
	tween.tween_interval(5.0)
	tween.tween_property(node, ^"scale", Vector2.ONE, 9.0)
	await tween.finished
	node.process_mode = Node.PROCESS_MODE_INHERIT


func populate_clouds() -> void:
	var path_top: Path2D = $CloudPathTop
	var path_bottom: Path2D = $CloudPathBottom
	
	for i: int in 16:
		var node := preload("res://scenes/route/parts/loop_cloud.tscn").instantiate()
		node.modulate = Color("#a0ccb6")
		node.radius = randi_range(16.0, 32.0)
		node.speed = 64.0
		node.z_index = 1
		path_top.add_child(node)
		node.progress_ratio = i / 16.0
	
	for i: int in 16:
		var node := preload("res://scenes/route/parts/loop_cloud.tscn").instantiate()
		node.modulate = Color("#92bbaf")
		node.radius = randi_range(12.0, 24.0)
		node.speed = 32.0
		node.v_offset = 24.0
		node.z_index = -1
		path_top.add_child(node)
		node.progress_ratio = i / 16.0
	
	for i: int in 16:
		var node := preload("res://scenes/route/parts/loop_cloud.tscn").instantiate()
		node.modulate = Color("#92bbaf")
		node.radius = randi_range(12.0, 24.0)
		node.speed = 32.0
		node.z_index = -1
		path_bottom.add_child(node)
		node.progress_ratio = i / 16.0
