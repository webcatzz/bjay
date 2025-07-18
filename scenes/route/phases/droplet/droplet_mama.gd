extends Node2D

const DROPLET_COUNT: int = 12


func pop() -> void:
	for i: int in DROPLET_COUNT:
		var node := preload("res://scenes/route/phases/droplet/droplet.tscn").instantiate()
		var curve := Curve2D.new()
		curve.add_point(position)
		curve.add_point(Route.edge(TAU * i / DROPLET_COUNT, position))
		get_parent().add_child.call_deferred(node)
		Route.guide.call_deferred(node, curve, 64.0)
	queue_free()
