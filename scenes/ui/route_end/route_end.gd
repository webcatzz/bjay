extends Node

const Constellation = preload("res://scenes/route/parts/constellation.gd")
const Stack = preload("res://scenes/route/parts/item_stack.gd")


func _ready() -> void:
	for item: Item in Game.inventory:
		$UndeliveredItems.item_types.append(item.type)
	
	var constellation: Constellation = $Constellation
	constellation.resize(Vector2i(Game.deliveries.size(), 1))
	
	var tween := create_tween()
	var idx: int = 0
	for place: Place in Game.deliveries:
		var node := constellation.add_node(Vector2i(idx, 0), place.type.icon)
		var stack := Stack.new()
		stack.position = Vector2(-5.0, -18.0)
		node.add_child(stack)
		for item: Item in Game.deliveries[place]:
			tween.tween_callback(stack.item_types.append.bind(item.type))
			tween.tween_callback(stack.queue_redraw)
			tween.tween_interval(0.1)
		idx += 1


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action(&"ui_accept") and not Game.wipe.visible:
		await Game.wipe.wipe_in(Color("#5b4ecc"))
		Game.start_route()
