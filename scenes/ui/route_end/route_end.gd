extends Node


func _ready() -> void:
	for item: Item in Game.inventory:
		if item.destination == Game.place:
			Game.delivered_items.append(item)
	Game.inventory.clear()
	
	var stack: Control = $MailStack
	var tween := create_tween()
	while not Game.delivered_items.is_empty():
		tween.tween_callback(stack.item_types.append.bind(Game.delivered_items.pop_back().type))
		tween.tween_callback(stack.queue_redraw)
		tween.tween_interval(0.1)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action(&"ui_accept"):
		Map.generate()
		get_tree().change_scene_to_file("res://scenes/route/route.tscn")
