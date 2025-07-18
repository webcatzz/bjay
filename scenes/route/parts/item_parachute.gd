extends Node2D

var item: Item


func _on_body_entered(body: Node2D) -> void:
	Game.add_item(item)
	queue_free()
