class_name RouteObject
extends Node2D

@onready var route: Route = get_tree().current_scene


func follow_path(curve: Curve2D, speed: float) -> MethodTweener:
	var tween := create_tween()
	var tweener := tween.tween_method(sample_path.bind(curve), 0.0, curve.get_baked_length(), curve.get_baked_length() / speed)
	tween.tween_callback(queue_free)
	return tweener


func sample_path(at: float, curve: Curve2D) -> void:
	position = curve.sample_baked(at)
