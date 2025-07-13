extends CharacterBody2D

var input: Vector2
var direction: Vector2
var speed: float = 200.0

@onready var invincibility_timer: Timer = $InvincibilityTimer


func take_damage() -> void:
	if invincibility_timer.is_stopped():
		Game.health -= 1
		if Game.inventory.size():
			parachute_item()
		set_invincible(true)
		invincibility_timer.start()


func set_invincible(value: bool) -> void:
	modulate.a = 0.5 if value else 1.0


func parachute_item() -> void:
	var idx: int = randi_range(0, Game.inventory.size() - 1)
	var item: Item = Game.inventory[idx]
	Game.remove_item(idx)
	var node := preload("res://scenes/route/parts/item_parachute.tscn").instantiate()
	node.item = item
	var curve := Curve2D.new()
	curve.add_point(position, Vector2.ZERO, Vector2(0.0, -32.0))
	curve.add_point(Vector2(position.x + randf_range(-64.0, 64.0), Route.RECT.end.y + 6.0))
	node.follow_path(curve, 32.0)
	get_parent().add_child.call_deferred(node)


func _unhandled_key_input(event: InputEvent) -> void:
	input = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")


func _physics_process(delta: float) -> void:
	direction = direction.lerp(input, 6.0 * delta)
	velocity = direction * speed
	move_and_slide()
