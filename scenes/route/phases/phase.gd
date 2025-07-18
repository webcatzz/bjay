class_name Phase
extends Node

@export_color_no_alpha var wipe_color: Color = Palette.WHITE

@onready var route: Route = get_tree().current_scene


func end() -> void:
	route.step()
