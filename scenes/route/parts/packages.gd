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
	custom_minimum_size = spacing * (item_types.size() - 1) + Vector2(8.0, 10.0)
	var point := Vector2(0.0, 1.0)
	for item_type: ItemType in item_types:
		draw_texture(item_type.texture, point + Vector2(0.0, roundf(sin(point.x * 3.0))))
		point += spacing
