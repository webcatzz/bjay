extends CharacterBody2D

enum State {MOVE, DASH_WINDUP, DASH, DEATH}

var input: Vector2
var direction: Vector2
var speed: float = 200.0

var state: State : set = _set_state
var is_invincible: bool
var dash_held_time: float : set = _set_dash_held_time
var dash_query_params := PhysicsShapeQueryParameters2D.new()

@onready var sprite: Node2D = $Sprite
@onready var animator: AnimationPlayer = $Animator
@onready var dash_bar: TextureProgressBar = $DashBar
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var route: Route = get_parent()


# movement

func _unhandled_key_input(event: InputEvent) -> void:
	input = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	if event.is_action_pressed(&"dash"):
		state = State.DASH_WINDUP
	elif event.is_action_released(&"dash"):
		if dash_bar.value == dash_bar.max_value:
			dash()
		else:
			state = State.MOVE


func _physics_process(delta: float) -> void:
	match state:
		State.MOVE:
			direction = direction.lerp(input, 6.0 * delta)
		State.DASH_WINDUP:
			dash_held_time += delta
			direction = direction.lerp(Vector2.ZERO, 6.0 * delta)
	velocity = direction * speed
	move_and_slide()


func _set_state(value: State) -> void:
	match state:
		State.DASH_WINDUP:
			dash_held_time = 0.0
			$Sprite/Tail.speed_scale = 1.0
	state = value
	match state:
		State.DASH_WINDUP:
			dash_held_time = 0.0
			$Sprite/Tail.speed_scale = 4.0


func _set_dash_held_time(value: float) -> void:
	dash_held_time = value
	dash_bar.value = value
	dash_bar.visible = value > 0.0


func dash() -> void:
	state = State.DASH
	set_invincible(true)
	
	var motion: Vector2 = (input if input else Vector2.RIGHT) * 100.0
	dash_query_params.transform = transform
	dash_query_params.motion = motion
	motion *= get_viewport().world_2d.direct_space_state.cast_motion(dash_query_params)[0]
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, ^"position", position + motion, 0.5)
	await tween.finished
	
	set_invincible(false)
	state = State.MOVE


# damage

func take_damage(amount: int = 1) -> void:
	if not is_invincible:
		Game.health -= amount


func set_invincible(value: bool) -> void:
	is_invincible = value
	sprite.modulate = Color(Color.WHITE, 0.5) if value else Color.WHITE


func parachute_item() -> void:
	var item_idx: int = randi_range(0, Game.inventory.size() - 1)
	var item: Item = Game.inventory[item_idx]
	Game.remove_item(item_idx)
	
	await get_tree().process_frame
	var node := preload("res://scenes/route/parts/item_parachute.tscn").instantiate()
	node.item = item
	node.position = position
	get_parent().add_child(node)
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(node, ^"scale", Vector2.ONE, 0.25).from(Vector2.ZERO)
	tween.tween_property(node, ^"position:y", Route.RECT.position.y, 0.5)
	await tween.finished
	node.position.x = Route.randf_along(0, -16.0)
	Route.guide(node, preload("res://assets/paths/parachute.tres"), 64.0)


func hitstop() -> void:
	get_tree().paused = true
	$HitstopTimer.start()


func _on_hitstop_ended() -> void:
	get_tree().paused = false
	input = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")


func die() -> void:
	state = State.DEATH
	$DeathParticles.emitting = true
	$UI/DeathOverlay.show()
	var tween := create_tween()
	tween.tween_property(self, ^"position", Vector2(position.x + 32.0, Route.RECT.end.y + 22.0), 4.0)
	tween.parallel().tween_property($UI/DeathOverlay, ^"modulate:a", 1.0, 4.0).from(0.0)
	tween.tween_callback(get_tree().change_scene_to_file.bind("res://scenes/ui/game_over.tscn"))


# ui

func _on_visibility_changed() -> void:
	$UI.visible = visible


func _on_health_changed(by: int) -> void:
	var ratio: float = 1.0 - float(Game.health) / Game.max_health
	$LowHealthParticles.amount_ratio = ratio
	$LowHealthParticles.modulate.a = ratio
	
	if Game.health == 0:
		die()
	
	elif by < 0:
		if state != State.DEATH:
			state = State.MOVE
		animator.play(&"hurt")
		if not Game.inventory.is_empty():
			parachute_item()
		hitstop()
		set_invincible(true)
		invincibility_timer.start()


func _on_inventory_changed() -> void:
	$UI/Bottom/Mail.visible = not Game.inventory.is_empty()
	$UI/Bottom/Mail/Sprites.display(Game.inventory)
	$UI/Bottom/Mail/Label.text = "×" + str(Game.inventory.size())


func _on_place_changed() -> void:
	var label: Label = $UI/Bottom/PlaceLabel
	label.text = Game.place.type.name
	label.modulate.a = 1.0
	label.show()
	var tween := create_tween()
	tween.tween_property(label, ^"visible_characters", label.text.length(), 0.1 * label.text.length()).from(0)
	tween.tween_interval(1.0)
	tween.tween_property(label, ^"modulate:a", 0.0, 0.25)
	tween.tween_callback(label.hide)


# init

func _ready() -> void:
	dash_query_params.collision_mask = 0b10
	dash_query_params.shape = $Collision.shape
	_on_inventory_changed()
	Game.health_changed.connect(_on_health_changed)
	Game.inventory_changed.connect(_on_inventory_changed)
	Game.place_changed.connect(_on_place_changed)
