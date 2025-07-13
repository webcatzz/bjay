extends Camera2D

var velocity: Vector2


func _unhandled_key_input(event: InputEvent) -> void:
	velocity = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down") * 200.0


func _physics_process(delta: float) -> void:
	position += velocity * delta
