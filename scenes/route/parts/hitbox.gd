extends Area2D

@export var damage: int = 1


func _on_body_entered(body: Node2D) -> void:
	if body is Route.Player:
		body.take_damage(damage)
