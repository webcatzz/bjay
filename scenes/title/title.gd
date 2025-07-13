extends Node


func _ready() -> void:
	$PanelContainer/VBox/Play.grab_focus()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/route/route.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
