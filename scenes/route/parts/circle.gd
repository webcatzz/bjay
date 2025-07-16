@tool
extends Node2D

@export var color: Color = Color.WHITE
@export_range(0.5, 64.0, 0.1, "or_greater") var radius: float = 4.0 : set = _set_radius


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)


func _set_radius(value: float) -> void:
	radius = value
	queue_redraw()
