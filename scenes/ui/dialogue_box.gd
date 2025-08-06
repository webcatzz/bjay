extends Control

const TYPING_DELAY: float = 0.04
const PUNCTUATION_TYPING_DELAY: float = 0.08
const PUNCTUATION: String = ".,?!"

@export var text_label: Label
@export var speaker_label: Label
@export var indicator: CanvasItem
@export var options_panel: Control
@export var options_list: Control
@export var typing_timer: Timer

var dialogue: Dialogue


func display(dlg: Dialogue) -> void:
	dialogue = dlg
	dlg.spoken.connect(set_text)
	dlg.speaker_changed.connect(set_speaker)
	dlg.prompted.connect(prompt)


func step() -> void:
	if typing_timer.is_stopped():
		dialogue.step()
	else:
		text_label.visible_characters = text_label.text.length()


func set_text(text: String) -> void:
	text_label.visible_characters = 0
	text_label.text = text
	indicator.hide()
	_type()


func set_speaker(speaker: String) -> void:
	speaker_label.text = speaker


func prompt(options: Dictionary[String, Callable]) -> void:
	for text: String in options:
		var button := preload("res://scenes/ui/dialogue_option.tscn").instantiate()
		button.text = text
		button.pressed.connect(options[text])
		button.pressed.connect(_on_option_selected)
		options_list.add_child(button)
	options_panel.show()


func _on_option_selected() -> void:
	options_panel.hide()
	for child: Node in options_list.get_children():
		child.queue_free()


func _type() -> void:
	text_label.visible_characters += 1
	if text_label.visible_characters < text_label.text.length():
		typing_timer.start(PUNCTUATION_TYPING_DELAY if text_label.text[text_label.visible_characters - 1] in PUNCTUATION else TYPING_DELAY)
	else:
		indicator.show()


func _ready() -> void:
	typing_timer.timeout.connect(_type)
