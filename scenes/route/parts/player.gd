extends CharacterBody2D

const MAX_HEAT: float = 5.0

var input: Vector2
var direction: Vector2
var speed: float = 200.0

var heat: float : set = _set_heat

var _modulates: Dictionary[String, Color]

@onready var sprite: Node2D = $Sprite
@onready var animator: AnimationPlayer = $Animator
@onready var heat_particles: GPUParticles2D = $HeatParticles
@onready var invincibility_timer: Timer = $InvincibilityTimer


# damage

func take_damage(amount: int = 1) -> void:
	if invincibility_timer.is_stopped():
		Game.health -= amount
		animator.play(&"hurt")
		if Game.inventory.size():
			parachute_item()
		set_invincible(true)
		invincibility_timer.start()


func set_invincible(value: bool) -> void:
	mix_modulate("invincible", Color(Color.WHITE, 0.5) if value else Color.WHITE)


func parachute_item() -> void:
	var idx: int = randi_range(0, Game.inventory.size() - 1)
	var item: Item = Game.inventory[idx]
	Game.remove_item(idx)
	var node := preload("res://scenes/route/parts/item_parachute.tscn").instantiate()
	node.item = item
	var curve := Curve2D.new()
	curve.add_point(position, Vector2.ZERO, Vector2(0.0, -32.0))
	curve.add_point(Vector2(position.x + randf_range(-64.0, 64.0), Route.RECT.end.y + 6.0))
	get_parent().add_child.call_deferred(node)
	Route.guide.call_deferred(node, curve, 32.0)


func _set_heat(value: float) -> void:
	if value > heat:
		heat_particles.restart()
		if value >= MAX_HEAT:
			take_damage()
	heat = clampf(value, 0.0, MAX_HEAT)
	mix_modulate("heat", Color.WHITE.lerp(Palette.RED, heat / MAX_HEAT))


# movement

func _unhandled_key_input(event: InputEvent) -> void:
	input = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")


func _physics_process(delta: float) -> void:
	direction = direction.lerp(input, 6.0 * delta)
	velocity = direction * speed
	heat -= delta
	move_and_slide()


# modulate

func mix_modulate(key: String, value: Color = Color.WHITE) -> void:
	_modulates[key] = value
	sprite.modulate = _modulates.values().reduce(_mix_colors)


func clear_modulate() -> void:
	_modulates.clear()
	sprite.modulate = Color.WHITE


func _mix_colors(a: Color, b: Color) -> Color:
	return a.lerp(b, 0.5)


# ui

func _ready() -> void:
	_on_inventory_changed()
	_on_health_changed()
	Game.inventory_changed.connect(_on_inventory_changed)
	Game.health_changed.connect(_on_health_changed)


func _on_inventory_changed() -> void:
	$UI/MailCount.text = str(Game.inventory.size()) + " mail"


func _on_health_changed() -> void:
	$UI/HealthBar.value = Game.health
