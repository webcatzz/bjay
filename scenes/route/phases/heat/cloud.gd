extends PathFollower

const SUN_POINT := Vector2(96.0, 16.0)

@export var extents: float
var polygon: PackedVector2Array

@onready var shade: Polygon2D = $Shade


func _ready() -> void:
	polygon.resize(4)
	polygon[0] = Vector2(-extents, 0.0)
	polygon[1] = Vector2(extents, 0.0)
	$Body/Collision.shape.a = Vector2(-extents, 0.0)
	$Body/Collision.shape.b = Vector2(extents, 0.0)
	$Sprite.scale.x = extents / 46.0
	$Sprite.scale.y = $Sprite.scale.x
	progress = 0.0


func _physics_process(delta: float) -> void:
	super(delta)
	_move_side(0, 3)
	_move_side(1, 2)
	shade.polygon = polygon


func _move_side(top_idx: int, bottom_idx: int) -> void:
	var vector: Vector2 = SUN_POINT.direction_to(global_position + polygon[top_idx])
	polygon[bottom_idx] = polygon[top_idx] + vector * (Route.RECT.size.y - global_position.y) / vector.y
