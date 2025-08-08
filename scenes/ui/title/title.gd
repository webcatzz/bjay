extends Node


func _ready() -> void:
	$Margins/VBox/Options/Play.grab_focus()


func _on_play_pressed() -> void:
	Game.wipe.fill()
	Game.start_route()


func _on_quit_pressed() -> void:
	get_tree().quit()
