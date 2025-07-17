extends RouteObject


func _ready() -> void:
	$Sprite.frame = randi_range(0, $Sprite.hframes - 1)
	$Sprite.flip_h = randf() < 0.5
	$Sprite.flip_v = randf() < 0.5
