class_name Dialogue

signal speaker_changed(speaker: String)
signal spoken(text: String)
signal prompted(options: PackedStringArray)
signal stopped

const START := "start "
const SEEK := "seek "
const STOP := "stop"
const SPEAKER := "as "
const OPTION := "opt "
const EXECUTE := "do "
const EVALUATE := "if "
const COMMENT := "x "
const INDENT := "\t"
const NEW_LINE := "\n"

var string: String
var idx: int
var indent: int
var dedent_stack: PackedInt32Array
var options: PackedInt32Array


func start(string: String, key: String = "") -> void:
	self.string = string
	if key:
		seek(key)
	else:
		idx = 0
		step()


func seek(key: String) -> void:
	idx = 0
	reset_indent()
	var target_line: String = START + key
	var line: String
	while true:
		line = get_line()
		if line.strip_edges() == target_line:
			indent = get_indent(line)
			break
		elif idx == string.length():
			push_error("Key \"%s\" not found in dialogue." % key)
			idx = 0
			break
	step()


func step() -> void:
	var line: String = get_line().strip_edges(false, true)
	if not line:
		step()
		return
	# indentation
	var line_indent: int = get_indent(line)
	if indent < line_indent:
		step()
		return
	elif indent > line_indent:
		if dedent_stack.is_empty():
			indent = line_indent
		else:
			idx = dedent_stack[-1]
			dedent_stack.resize(dedent_stack.size() - 1)
			step()
			return
	line = line.strip_edges(true, false)
	# tokens
	if line.begins_with(SPEAKER):
		speaker_changed.emit(line.substr(SPEAKER.length()))
		step()
	elif line.begins_with(OPTION):
		var option_strings: PackedStringArray
		while idx < string.length():
			if line and get_indent(line) == indent:
				line = line.substr(indent)
				if line.begins_with(OPTION):
					options.append(idx)
					option_strings.append(line.substr(OPTION.length()))
				else:
					dedent_stack.append(idx)
					break
			line = get_line()
		prompted.emit(option_strings)
	elif line.begins_with(EXECUTE):
		run(line.substr(EXECUTE.length()))
		step()
	elif line.begins_with(EVALUATE):
		if run(line.substr(EVALUATE.length())):
			indent += 1
		step()
	elif line.begins_with(START) or line.begins_with(COMMENT):
		step()
	elif line.begins_with(SEEK):
		seek(line.substr(SEEK.length()))
	elif line.begins_with(STOP):
		stop()
	else:
		spoken.emit(line)


func select(option: int) -> void:
	idx = options[option]
	options.clear()
	indent += 1
	step()


func stop() -> void:
	idx = 0
	reset_indent()
	stopped.emit()


# helpers

func get_line() -> String:
	var start: int = idx
	var end: int = string.find(NEW_LINE, start)
	idx = end + 1
	return string.substr(start, end - start)


func get_indent(line: String) -> int:
	var indent: int = 0
	while indent < line.length() and line[indent] == INDENT:
		indent += 1
	return indent


func reset_indent() -> void:
	indent = 0
	dedent_stack.clear()


func run(code: String) -> Variant:
	var expr := Expression.new()
	expr.parse(code, ["Game"])
	return expr.execute([Game])
