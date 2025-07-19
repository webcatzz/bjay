extends Node

signal inventory_changed
signal health_changed

var inventory: Array[Item]
var health: int = 100000000000 : set = _set_health
var place: Place : set = _set_place

var babble_friendship: int


# inventory

func add_item(item: Item) -> void:
	inventory.append(item)
	inventory_changed.emit()


func remove_item(idx: int) -> void:
	inventory.remove_at(idx)
	inventory_changed.emit()


# health

func _set_health(value: int) -> void:
	health = value
	health_changed.emit()
	if health <= 0:
		get_tree().change_scene_to_file.call_deferred("res://scenes/ui/game_over.tscn")


# place

func _set_place(value: Place) -> void:
	place = value
	if place == Map.destination:
		Map.origin = Map.destination
		Map.destination = Place.new()
		Map.generate()


# pausing

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		get_tree().paused = not get_tree().paused
		$Pause.visible = get_tree().paused


# init

func _ready() -> void:
	for i: int in 20:
		var item := Item.new()
		item.type = preload("res://resources/item_type/package.tres")
		add_item(item)
