class_name PathFollower
extends PathFollow2D

signal looped

@export_range(0.0, 128.0, 0.1, "or_greater") var speed: float = 1.0
@export var free_once_looped: bool


func _physics_process(delta: float) -> void:
	var prev_progress: float = progress
	progress += speed * delta
	if prev_progress > progress:
		if free_once_looped:
			queue_free()
		else:
			looped.emit()
