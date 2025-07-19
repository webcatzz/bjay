extends Node2D

@export var radius: float = 4.0


func _ready() -> void:
	$Hitbox/Collision.shape.radius = radius


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE)
