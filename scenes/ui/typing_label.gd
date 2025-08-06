extends Label

const PUNCTUATION: String = ".,?!"

@export_range(0.01, 10.0, 0.01) var typing_delay: float = 0.04
@export_range(0.01, 10.0, 0.01) var punctuation_typing_delay: float = 0.08

signal finished

@onready var timer: Timer = $Timer


func type(string: String) -> void:
	visible_characters = 0
	text = string
	_type()


func skip() -> void:
	visible_characters = text.length()


func is_finished() -> bool:
	return timer.is_stopped()


func _type() -> void:
	visible_characters += 1
	if visible_characters < text.length():
		timer.start(punctuation_typing_delay if text[visible_characters - 1] in PUNCTUATION else typing_delay)
	else:
		finished.emit()
