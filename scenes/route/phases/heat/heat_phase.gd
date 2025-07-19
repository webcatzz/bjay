extends Phase

@onready var sun: Sprite2D = $Background/Sun
@onready var gradient: Gradient = $Background/Gradient.texture.gradient


func _ready() -> void:
	$Timer.start(randf_range(10.0, 25.0))
	var gradient: Gradient = $Background/Gradient.texture.gradient
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_loops(-1)
	tween.tween_method(_set_gradient_offset, 0.25, 0.5, 4.0)
	tween.tween_method(_set_gradient_offset, 0.5, 0.25, 4.0)
	cloud()


func cloud() -> void:
	var node := preload("res://scenes/route/phases/heat/cloud.tscn").instantiate()
	node.speed = randf_range(24.0, 48.0)
	node.extents = randf_range(16.0, 48.0)
	node.v_offset = Route.randf_along(1, -32.0)
	$CloudPath.add_child(node)


func ripple() -> void:
	var bullet_count: int = 12
	var initial_angle: float = 0.0 if randf() < 0.5 else PI / bullet_count
	for i: int in bullet_count:
		var node := preload("res://scenes/route/phases/heat/bullet.tscn").instantiate()
		var curve := Curve2D.new()
		curve.add_point(sun.position)
		curve.add_point(Route.edge(initial_angle + TAU * i / bullet_count, sun.position))
		add_child(node)
		Route.guide(node, curve, 32.0, true)


func is_in_shade(node: Node2D) -> bool:
	return not get_viewport().world_2d.direct_space_state.intersect_ray(PhysicsRayQueryParameters2D.create(sun.global_position, node.global_position, 0b100)).is_empty()


func _physics_process(delta: float) -> void:
	for bullet: Node in get_tree().get_nodes_in_group("disable_in_shade"):
		var disabled: bool = is_in_shade(bullet)
		bullet.modulate = Color("#ff3300", 0.5) if disabled else Color.WHITE
		bullet.process_mode = Node.PROCESS_MODE_DISABLED if disabled else Node.PROCESS_MODE_INHERIT


func _set_gradient_offset(value: float) -> void:
	gradient.set_offset(1, value)
