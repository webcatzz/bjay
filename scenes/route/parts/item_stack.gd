@tool
extends Control

@export var item_types: Array[ItemType]
@export var spacing: Vector2


func display(items: Array[Item]) -> void:
	item_types.resize(items.size())
	for i: int in items.size():
		item_types[i] = items[i].type
	queue_redraw()


func _draw() -> void:
	var length: Vector2 = spacing * maxf(item_types.size() - 1, 0.0)
	var point: Vector2 = Vector2(1.0, 1.0) - length.minf(0.0)
	custom_minimum_size = Vector2(10.0, 10.0) + length.abs()
	for item_type: ItemType in item_types:
		draw_texture(item_type.texture, point + Vector2(sin(point.y * spacing.y * 0.25), sin(point.x * spacing.x * 0.25)).round())
		point += spacing
