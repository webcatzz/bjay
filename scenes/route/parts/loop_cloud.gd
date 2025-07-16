extends "res://scenes/route/parts/path_follower.gd"

var radius: float : set = _set_radius


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE)


func _set_radius(value: float) -> void:
	radius = value
	queue_redraw()
