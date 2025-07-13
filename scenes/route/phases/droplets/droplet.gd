extends RouteObject


func _on_body_entered(body: Node2D) -> void:
	body.take_damage()
