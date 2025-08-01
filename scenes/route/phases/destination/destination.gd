extends Phase


func _ready() -> void:
	route.player.hide()
	route.player.process_mode = Node.PROCESS_MODE_DISABLED
	
	var i: int = 0
	while i < Game.inventory.size():
		if Game.inventory[i].address == Game.place.type.name:
			Game.delivered_items.append(Game.inventory.pop_at(i))
		else:
			i += 1
	
	var stack: Control = $MailStack
	var tween := create_tween()
	while not Game.delivered_items.is_empty():
		tween.tween_callback(stack.item_types.append.bind(Game.delivered_items.pop_back().type))
		tween.tween_callback(stack.queue_redraw)
		tween.tween_interval(0.1)


func end() -> void:
	Map.generate()
	get_tree().change_scene_to_file("res://scenes/route/route.tscn")


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action(&"ui_accept"):
		end()
