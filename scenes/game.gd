extends Node

const Wipe = preload("res://scenes/ui/wipe.gd")

signal inventory_changed
signal health_changed(by: int)
signal place_changed

var inventory: Array[Item]
var max_health: int = 10
var health: int = max_health : set = _set_health
var place: Place : set = _set_place

var deliveries: Dictionary[Place, Array]
var data: Dictionary[String, Variant]

var total_routes_completed: int
var total_mail_delivered: int
var total_mail_lost: int

@onready var wipe: Wipe = $Wipe


func start_route() -> void:
	health = max_health
	inventory.clear()
	deliveries.clear()
	
	match total_routes_completed if total_routes_completed < 5 else randf_range(0, 4):
		0: Map.size = Vector2i(2, 1)
		1: Map.size = Vector2i(3, 2)
		2: Map.size = Vector2i(4, 2)
		3: Map.size = Vector2i(5, 3)
		4: Map.size = Vector2i(7, 3)
	Map.generate()
	
	for i: int in 5:
		var item := Item.new()
		item.type = load("res://resources/item_type/package.tres")
		item.destination = Map.destination
		add_item(item)
	get_tree().change_scene_to_file("res://scenes/route/route.tscn")


# inventory

func add_item(item: Item) -> void:
	inventory.append(item)
	inventory_changed.emit()


func remove_item(idx: int) -> void:
	inventory.remove_at(idx)
	inventory_changed.emit()


func deliver_item(idx: int) -> void:
	var item: Item = inventory[idx]
	deliveries.get_or_add(item.destination, []).append(item)
	remove_item(idx)
	total_mail_delivered += 1


# health

func _set_health(value: int) -> void:
	var by: float = value - health
	health = value
	health_changed.emit(by)


# place

func _set_place(value: Place) -> void:
	place = value
	place_changed.emit()


# pause

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		get_tree().paused = !get_tree().paused
		$Pause.visible = get_tree().paused
