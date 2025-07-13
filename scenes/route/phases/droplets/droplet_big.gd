extends RouteObject

const DROPLET_COUNT: int = 12


func pop() -> void:
	for i: int in DROPLET_COUNT:
		var node := preload("res://scenes/route/phases/droplets/droplet.tscn").instantiate()
		var curve := Curve2D.new()
		curve.add_point(position)
		curve.add_point(Route.edge(TAU * i / DROPLET_COUNT, position))
		node.follow_path(curve, 32.0)
		get_parent().add_child.call_deferred(node)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	body.take_damage()
	pop()


func _on_area_entered() -> void:
	pop()
