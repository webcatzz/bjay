@tool
class_name CloudLayer
extends Node2D

@export var curve: Curve2D
@export_range(1.0, 128.0, 1.0, "or_greater", "suffix:px/s") var speed: float = 32.0
@export var point_count: int = 8
@export var corners: PackedVector2Array

var progress: float


func _physics_process(delta: float) -> void:
	if not curve or curve.point_count < 2: return
	progress = fmod(progress + speed * delta, curve.get_baked_length())
	queue_redraw()


func _draw() -> void:
	var offsets: Array[float] = [0.0, curve.get_baked_length()]
	for i: int in point_count:
		offsets.append(fmod(progress + curve.get_baked_length() * i / point_count, curve.get_baked_length()))
	offsets.sort()
	var points: PackedVector2Array = offsets.map(curve.sample_baked)
	
	for i: int in points.size() - 1:
		var center: Vector2 = points[i].lerp(points[i + 1], 0.5)
		draw_circle(center, points[i].distance_to(center), Color.WHITE)
	
	points.append_array(corners)
	draw_colored_polygon(points, Color.WHITE)
