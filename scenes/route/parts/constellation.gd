extends Node2D

const SEPARATION := Vector2(24.0, 16.0)
const BOB_DURATION: float = 4.0

var edges: Array[Dictionary]


func resize(size: Vector2i) -> void:
	position -= Vector2(size - Vector2i.ONE) * SEPARATION * 0.5


func add_node(coords: Vector2i, texture: Texture2D = null) -> Node2D:
	var node: Node2D
	if texture:
		node = Sprite2D.new()
		node.texture = texture
	else:
		node = preload("res://scenes/route/parts/constellation_star.tscn").instantiate()
	var point: Vector2 = Vector2(coords) * SEPARATION
	node.position = point + Vector2(sin(point.y), sin(point.x)) * 4.0
	add_child(node)
	var tween := node.create_tween().set_trans(Tween.TRANS_CUBIC).set_loops(-1)
	tween.tween_property(node, ^"position:y", node.position.y - 2.0, BOB_DURATION)
	tween.tween_property(node, ^"position:y", node.position.y + 2.0, BOB_DURATION)
	tween.custom_step(sin(node.position.x * 0.025) * BOB_DURATION)
	return node


func add_edge(start_node: Node2D, end_node: Node2D) -> int:
	edges.append({start = start_node, end = end_node})
	queue_redraw()
	return edges.size() - 1


func set_edge_color(idx: int, color: Color) -> void:
	edges[idx].color = color
	queue_redraw()


func set_edge_method(idx: int, method: Callable) -> void:
	edges[idx].method = method
	queue_redraw()


func _draw() -> void:
	for edge: Dictionary in edges:
		draw_edge(edge.start.position, edge.end.position, edge.get("color", Palette.NIGHT[1]), edge.get("method", draw_line))


func draw_edge(start_point: Vector2, end_point: Vector2, color: Color, method: Callable) -> void:
	method.call(start_point.move_toward(end_point, 8.0), end_point.move_toward(start_point, 8.0), color)
