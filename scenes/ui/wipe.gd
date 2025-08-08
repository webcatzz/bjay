extends Control


func wipe_in(color: Color = modulate) -> void:
	modulate = color
	anchor_left = 1.0
	anchor_right = 2.0
	_randomize_texture()
	show()
	await create_tween().tween_property(self, ^"anchor_left", -1.0, 1.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN).finished


func wipe_out(color: Color = modulate) -> void:
	anchor_left = -1.0
	anchor_right = 2.0
	_randomize_texture()
	var tween := create_tween().set_parallel()
	tween.tween_property(self, ^"modulate", color, 0.25).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, ^"anchor_right", 0.0, 1.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	await tween.finished
	hide()


func fill(color: Color = modulate) -> void:
	modulate = color
	anchor_left = -1.0
	anchor_right = 2.0
	show()


func _randomize_texture() -> void:
	add_theme_stylebox_override(&"panel", preload("res://assets/ui/wipe_1.tres") if randf() < 0.5 else preload("res://assets/ui/wipe_2.tres"))
