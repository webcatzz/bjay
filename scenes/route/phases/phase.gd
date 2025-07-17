class_name Phase
extends Node

@onready var route: Route = get_tree().current_scene


func end() -> void:
	route.step()
