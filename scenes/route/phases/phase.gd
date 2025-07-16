class_name Phase
extends Node

@onready var route: Route = get_tree().current_scene


func _ready() -> void:
	await route.wipe_out()


func end() -> void:
	route.wipe_to(preload("res://scenes/route/phases/night/night_phase.tscn"), self)
