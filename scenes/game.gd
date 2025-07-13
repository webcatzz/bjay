extends Node

signal inventory_changed
signal health_changed
signal moved

var inventory: Array[Item]
var health: int = 20 : set = _set_health

var origin: Place
var destination: Place
var place: Place

var map_places: Array[Place]
var map_size := Vector2i(5, 3)


# map

func start() -> void:
	var mapgen := preload("res://scenes/mapgen.gd").new()
	mapgen.size = map_size
	map_places = mapgen.generate(origin, destination)
	place = origin


func move_to(new_place: Place) -> void:
	place = new_place
	moved.emit()


func end() -> void:
	pass


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
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")


# init

func _ready() -> void:
	for i: int in 20:
		var item := Item.new()
		item.type = preload("res://resources/item_type/package.tres")
		add_item(item)
	
	origin = Place.new()
	destination = Place.new()
	start()
