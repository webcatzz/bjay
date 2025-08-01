extends Node2D

var item: Item


func _ready() -> void:
	$Sprite.texture = item.type.texture


func _on_body_entered(body: Node2D) -> void:
	Game.add_item(item)
	queue_free()
