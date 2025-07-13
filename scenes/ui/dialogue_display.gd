extends Node

const TYPING_DELAY: float = 0.04
const PUNCTUATION_TYPING_DELAY: float = 0.08
const PUNCTUATION: String = ".,?!"

var dialogue := Dialogue.new()

@onready var box: Panel = $Box
@onready var speaker_label: Label = $Box/Speaker
@onready var text_label: Label = $Box/Text
@onready var indicator: TextureRect = $Box/Text/Indicator
@onready var options_box: PanelContainer = $Box/Options
@onready var options_list: VBoxContainer = $Box/Options/VBox
@onready var typing_timer: Timer = $TypingTimer
@onready var animator: AnimationPlayer = $Animator


func display(string: String, key: String = "") -> void:
	dialogue.start(FileAccess.get_file_as_string("res://resources/dialogue/test.dialogue"), key)
	animator.play(&"intro")


func _type() -> void:
	text_label.visible_characters += 1
	if text_label.visible_characters < text_label.text.length():
		typing_timer.start(PUNCTUATION_TYPING_DELAY if text_label.text[text_label.visible_characters - 1] in PUNCTUATION else TYPING_DELAY)
	else:
		indicator.show()


func _ready() -> void:
	dialogue.speaker_changed.connect(_on_speaker_changed)
	dialogue.spoken.connect(_on_spoken)
	dialogue.prompted.connect(_on_prompted)
	dialogue.stopped.connect(_on_stopped)


func _on_speaker_changed(speaker: String) -> void:
	speaker_label.text = speaker


func _on_spoken(text: String) -> void:
	text_label.text = text
	text_label.visible_characters = 0
	typing_timer.start(TYPING_DELAY)
	indicator.hide()
	box.grab_focus()


func _on_prompted(options: PackedStringArray) -> void:
	for i: int in options.size():
		var node := preload("res://scenes/ui/dialogue_option.tscn").instantiate()
		node.text = options[i]
		node.pressed.connect(_on_selected.bind(i))
		options_list.add_child(node)
	options_box.show()
	options_list.get_child(0).grab_focus()
	box.focus_mode = Control.FOCUS_NONE


func _on_selected(idx: int) -> void:
	dialogue.select(idx)
	options_box.hide()
	for child: Node in options_list.get_children():
		child.queue_free()
	box.focus_mode = Control.FOCUS_ALL
	box.grab_focus()


func _on_stopped() -> void:
	box.focus_mode = Control.FOCUS_NONE
	animator.play(&"outro")


func _on_box_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept"):
		if typing_timer.is_stopped():
			dialogue.step()
		else:
			typing_timer.stop()
			text_label.visible_ratio = 1.0
			indicator.show()
		box.accept_event()
