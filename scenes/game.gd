extends Node

signal inventory_changed
signal health_changed(by: int)
signal place_changed

var inventory: Array[Item]
var max_health: int = 10
var health: int = max_health : set = _set_health
var place: Place : set = _set_place

var delivered_items: Dictionary[Place, Array]
var data: Dictionary[String, Variant]


# inventory

func add_item(item: Item) -> void:
	inventory.append(item)
	inventory_changed.emit()


func remove_item(item: Item) -> void:
	inventory.erase(item)
	inventory_changed.emit()


func deliver_item(item: Item) -> void:
	delivered_items.get_or_add(item.destination, []).append(item)
	remove_item(item)


# health

func _set_health(value: int) -> void:
	var by: float = value - health
	health = value
	health_changed.emit(by)


# place

func _set_place(value: Place) -> void:
	place = value
	place_changed.emit()
	for item: Item in inventory:
		if item.destination == place:
			deliver_item(item)


# pause

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		get_tree().paused = !get_tree().paused
		$Pause.visible = get_tree().paused
