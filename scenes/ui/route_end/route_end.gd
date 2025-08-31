extends Node

const Constellation = preload("res://scenes/route/parts/constellation.gd")
const Stack = preload("res://scenes/route/parts/item_stack.gd")


func _ready() -> void:
	Game.total_routes_completed += 1
	# undelivered
	for item: Item in Game.inventory:
		$UndeliveredItems.item_types.append(item.type)
	# constellation
	var constellation: Constellation = $Constellation
	constellation.resize(Vector2i(Game.deliveries.size(), 1))
	# stars + delivered stacks
	var tween := create_tween()
	var idx: int = 0
	var item_count: int = 0
	for place: Place in Game.deliveries:
		var node := constellation.add_node(Vector2i(idx, 0), place.type.icon)
		var stack := Stack.new()
		stack.position = Vector2(-5.0, -8.0)
		stack.spacing.y = -6.0
		stack.grow_vertical = Control.GROW_DIRECTION_BEGIN
		node.add_child(stack)
		for item: Item in Game.deliveries[place]:
			tween.tween_callback(stack.item_types.append.bind(item.type))
			tween.tween_callback(stack.queue_redraw)
			tween.tween_interval(0.1)
			item_count += 1
		idx += 1
	# edges
	for i: int in range(1, constellation.get_child_count() - 1):
		constellation.add_edge(constellation.get_child(i), constellation.get_child(i + 1))
	# total item count
	var item_count_label: Label = $Constellation/ItemCount
	item_count_label.position.x = constellation.get_child(-1).position.x + 12.0
	item_count_label.text = "×" + str(item_count)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action(&"ui_accept") and not Game.wipe.visible:
		$InputHint.hide()
		await Game.wipe.wipe_in(Color("#5b4ecc"))
		Game.start_route()
