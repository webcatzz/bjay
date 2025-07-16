extends Area2D

@export_range(1, 20, 1, "or_greater") var damage: int = 1


func _on_body_entered(body: Node2D) -> void:
	body.take_damage(damage)
