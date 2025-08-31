class_name Dialogue

signal spoken(text: String)
signal speaker_changed(speaker: String)
signal prompted(options: Dictionary[String, Callable])
signal ended

var queue: Array[Callable]
var idx: int = -1


func step() -> void:
	idx += 1
	if idx < queue.size():
		queue[idx].call()
	else:
		queue.clear()
		ended.emit()


func push(callback: Callable) -> void:
	queue.append(callback)


func speaker(speaker: String) -> void:
	push(speaker_changed.emit.bind(speaker))


func say(text: String) -> void:
	push(spoken.emit.bind(text))


func prompt(options: Dictionary[String, Callable]) -> void:
	push(prompted.emit.bind(options))
