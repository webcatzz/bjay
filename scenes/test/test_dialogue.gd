extends Node

@export_file("*.dialogue") var file: String
@export var key: String

func _ready() -> void:
	$DialogueDisplay.display(FileAccess.get_file_as_string(file), key)
