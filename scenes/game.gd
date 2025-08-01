extends Node

signal inventory_changed
signal health_changed(by: int)
signal place_changed

const MAX_HEALTH: int = 10

var inventory: Array[Item]
var health: int = MAX_HEALTH : set = _set_health
var place: Place : set = _set_place

var data: Dictionary[String, Variant]

@onready var music: AudioStreamPlayer = $Music


# inventory

func add_item(item: Item) -> void:
	inventory.append(item)
	inventory_changed.emit()


func remove_item(idx: int) -> void:
	inventory.remove_at(idx)
	inventory_changed.emit()


# health

func _set_health(value: int) -> void:
	var by: float = value - health
	health = value
	health_changed.emit(by)
	if health <= 0:
		get_tree().change_scene_to_file.call_deferred("res://scenes/ui/game_over.tscn")


# place

func _set_place(value: Place) -> void:
	place = value
	place_changed.emit()
	if place == Map.destination:
		Map.origin = Map.destination
		Map.destination = Place.new()
		Map.generate()


# music

func play_music(stream: AudioStream) -> void:
	music.stream = stream
	music.play()


# pause

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		get_tree().paused = !get_tree().paused
		$Pause.visible = get_tree().paused


# init

func _ready() -> void:
	for i: int in 20:
		var item := Item.new()
		item.type = preload("res://resources/item_type/package.tres")
		add_item(item)
