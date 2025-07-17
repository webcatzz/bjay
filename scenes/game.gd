extends Node

signal inventory_changed
signal health_changed

var inventory: Array[Item]
var health: int = 100000000000 : set = _set_health
var place: Place : set = _set_place


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
		get_tree().change_scene_to_file.call_deferred("res://scenes/game_over.tscn")


# place

func _set_place(value: Place) -> void:
	place = value
	if place == Map.destination:
		Map.origin = Map.destination
		Map.destination = Place.new()
		Map.generate()


# init

func _ready() -> void:
	for i: int in 20:
		var item := Item.new()
		item.type = preload("res://resources/item_type/package.tres")
		add_item(item)
