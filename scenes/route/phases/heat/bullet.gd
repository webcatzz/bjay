extends PathFollower

@onready var collision: CollisionShape2D = $Hitbox/Collision


func set_disabled(value: bool) -> void:
	visible = not value
	collision.disabled = value
