extends Control


func wipe_in() -> void:
	randomize_texture()
	anchor_left = 1.0
	anchor_right = 2.0
	show()
	await create_tween().tween_property(self, ^"anchor_left", -1.0, 1.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN).finished


func wipe_out() -> void:
	randomize_texture()
	anchor_left = -1.0
	anchor_right = 2.0
	await create_tween().tween_property(self, ^"anchor_right", 0.0, 1.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT).finished
	hide()


func randomize_texture() -> void:
	add_theme_stylebox_override(&"panel", preload("res://assets/ui/wipe_1.tres") if randf() < 0.5 else preload("res://assets/ui/wipe_2.tres"))
