extends Node

const Stack = preload("res://scenes/route/parts/packages.gd")


func _ready() -> void:
	fill_stack($UndeliveredItems, Game.inventory)
	for place: Place in Game.delivered_items:
		var stack := Stack.new()
		stack.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		stack.spacing.y = -6.0
		fill_stack(stack, Game.delivered_items[place])
		$DeliveredItems.add_child(stack)


func fill_stack(stack: Stack, array: Array, delay: float = 0.0) -> void:
	var tween := create_tween()
	for item: Item in array:
		tween.tween_callback(stack.item_types.append.bind(item.type))
		tween.tween_callback(stack.queue_redraw)
		tween.tween_interval(0.1)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action(&"ui_accept"):
		Map.generate()
		get_tree().change_scene_to_file("res://scenes/route/route.tscn")
