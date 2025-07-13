extends PathFollow2D

var radius: float : set = _set_radius
var speed: float


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE)


func _process(delta: float) -> void:
	progress += speed * delta


func _set_radius(value: float) -> void:
	radius = value
	queue_redraw()
