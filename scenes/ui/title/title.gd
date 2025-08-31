extends Node

@onready var animator: AnimationPlayer = $Animator


func _ready() -> void:
	animator.queue(&"webcatz")
	animator.queue(&"title")


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept"):
		var queue: PackedStringArray = animator.get_queue()
		if not queue.is_empty(): animator.play(queue[0])


func _on_play_pressed() -> void:
	Game.wipe.fill()
	Game.start_route()


func _on_quit_pressed() -> void:
	get_tree().quit()
