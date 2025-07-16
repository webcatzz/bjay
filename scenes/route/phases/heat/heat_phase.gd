extends Phase

@onready var sun: Sprite2D = $Background/Sun
@onready var gradient: Gradient = $Background/Gradient.texture.gradient


func _ready() -> void:
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


func beam(angle: float, radius: float, hole_y: float, hole_radius: float) -> void:
	var node := preload("res://scenes/route/phases/heat/beam.tscn").instantiate()
	node.angle = angle
	node.radius = radius
	node.hole_y = hole_y
	node.hole_radius = hole_radius
	sun.add_child(node)


func rand_beam() -> void:
	beam(randf_range(PI * -0.25, PI * 0.25), randf_range(8.0, 24.0), randf_range(32.0, 80.0), randf_range(16.0, 32.0))


func heat() -> void:
	if not is_in_shade(route.player):
		route.player.heat += 2.0


func is_in_shade(node: Node2D) -> bool:
	return not get_viewport().world_2d.direct_space_state.intersect_ray(PhysicsRayQueryParameters2D.create(sun.global_position, node.global_position, 0b100)).is_empty()


func _physics_process(delta: float) -> void:
	route.player.mix_modulate("shade", Color.WEB_GRAY if is_in_shade(route.player) else Color.WHITE)


func _set_gradient_offset(value: float) -> void:
	gradient.set_offset(1, value)
