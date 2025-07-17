extends RouteObject

const MAX_DEVIATION: float = 16.0

var end: Vector2
var attack_delay: float

@onready var line: Line2D = $Line
@onready var hitbox: Area2D = $Hitbox
@onready var animator: AnimationPlayer = $Animator


func generate_points(end: Vector2) -> PackedVector2Array:
	var points: PackedVector2Array
	var end_point: Vector2 = end - position
	var point_num: int = randf_range(4, 16)
	points.append(Vector2.ZERO)
	for i: int in point_num:
		points.append(end_point * (i + 1) / float(point_num + 1) + Vector2.from_angle(randf_range(0.0, TAU)) * randf_range(0.0, MAX_DEVIATION))
	points.append(end_point)
	return points


func _ready() -> void:
	# telegraph
	var points: PackedVector2Array = generate_points(end)
	line.width = 1.0
	line.modulate.a = 0.5
	var tween: Tween = create_tween()
	var delay: float = 0.1 / points.size()
	for point: Vector2 in points:
		tween.tween_callback(line.add_point.bind(point))
		tween.tween_interval(delay)
	tween.tween_property(line, ^"modulate:a", 0.125, 0.5)
	tween.tween_interval(attack_delay)
	await tween.finished
	# strike
	#route.background.flash(Palette.WHITE.lerp(Palette.THUNDER_BACKGROUND, 0.5), 0.0, 0.5)
	line.points = generate_points(end)
	line.width = 8.0
	line.modulate.a = 1.0
	for i: int in line.get_point_count() - 1:
		_add_collision(line.get_point_position(i), line.get_point_position(i + 1))
	animator.play(&"fade_out")


func _add_collision(start: Vector2, end: Vector2) -> void:
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size.x = start.distance_to(end)
	shape.size.y = 8.0
	collision.rotation = start.angle_to_point(end)
	collision.position = start + Vector2(shape.size.x * 0.5, 0.0).rotated(collision.rotation)
	collision.shape = shape
	hitbox.add_child(collision)


func _on_body_entered(body: Node2D) -> void:
	if body == route.player:
		route.player.take_damage(25)
