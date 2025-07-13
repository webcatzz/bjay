@tool
extends EditorSyntaxHighlighter

var settings: EditorSettings = EditorInterface.get_editor_settings()


func _get_name() -> String:
	return "Dialogue"


func _get_supported_languages() -> PackedStringArray:
	return ["dialogue"]


func _get_line_syntax_highlighting(idx: int) -> Dictionary:
	var line: String = get_text_edit().get_line(idx)
	if line.strip_edges():
		# indent
		var indent: int
		while line[indent] == "\t":
			indent += 1
		line = line.substr(indent)
		# keywords
		for keyword: String in [Dialogue.SPEAKER, Dialogue.EXECUTE, Dialogue.EVALUATE]:
			if line.begins_with(keyword):
				return _prefix("keyword", indent, keyword.length())
		for keyword: String in [Dialogue.START, Dialogue.SEEK, Dialogue.STOP, Dialogue.OPTION]:
			if line.begins_with(keyword):
				return _prefix("control_flow_keyword", indent, keyword.length())
		if line.begins_with(Dialogue.COMMENT):
			return {indent: {color = settings.get_setting("text_editor/theme/highlighting/comment_color")}}
	return {}


func _prefix(type: String, start: int, length: int) -> Dictionary:
	return {
		start: {color = _color(type)},
		start + length: {color = _color("text")},
	}


func _color(type: String) -> Color:
	return settings.get_setting("text_editor/theme/highlighting/%s_color" % type)
