extends Node2D

@export var color: Color = Color.WHITE
@export_range(-89, 89, 1.0, "radians_as_degrees") var angle: float = 0.0
@export var radius: float = 32.0
@export var hole_y: float = 64.0
@export var hole_radius: float = 16.0

var polygons: Array[PackedVector2Array]


func _ready() -> void:
	var py: float = Route.RECT.end.y - global_position.y
	var px: float = tan(angle) * py
	polygons = Geometry2D.clip_polygons(
		[Vector2.ZERO, Vector2(px + radius, py), Vector2(px - radius, py)],
		Geometry2D.offset_polyline([Vector2(-100.0, hole_y), Vector2(100.0, hole_y)], hole_radius)[0],
	)
	for polygon: PackedVector2Array in polygons:
		var shrunk: Array[PackedVector2Array] = Geometry2D.offset_polygon(polygon, -4.0)
		if not shrunk.is_empty():
			var node := CollisionPolygon2D.new()
			node.polygon = shrunk[0]
			$Hitbox.add_child(node)


func _draw() -> void:
	for polygon: PackedVector2Array in polygons:
		draw_colored_polygon(polygon, color)


func _on_body_entered(body: Node2D) -> void:
	body.heat = body.MAX_HEAT
