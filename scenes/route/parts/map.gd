extends RouteObject

const SEPARATION := Vector2(24.0, 16.0)
const BOB_DURATION: float = 4.0

var nodes: Dictionary[Place, Node2D]
var player_idx: int

@onready var player: Node2D = $"../../../Player"


func _ready() -> void:
	position -= Vector2(Game.map_size + Vector2i(1, -1)) * SEPARATION * 0.5
	for place: Place in Game.map_places:
		var node: Node2D
		if place.coords.x < Game.place.coords.x or place.coords.x == Game.place.coords.x and place.coords.y != Game.place.coords.y or not place.type.icon:
			node = preload("res://scenes/route/parts/map_star.tscn").instantiate()
		else:
			node = Sprite2D.new()
			node.texture = place.type.icon
		node.position = coords_to_point(place.coords)
		nodes[place] = node
		add_child(node)
		var tween := node.create_tween().set_trans(Tween.TRANS_CUBIC).set_loops(-1)
		tween.tween_property(node, ^"position:y", node.position.y - 2.0, BOB_DURATION)
		tween.tween_property(node, ^"position:y", node.position.y + 2.0, BOB_DURATION)
		tween.custom_step(sin(node.position.x * 0.025) * BOB_DURATION)


func _draw() -> void:
	for place: Place in Game.map_places:
		var point: Vector2 = nodes[place].position
		var method: Callable = draw_dashed_line if place.coords.x == Game.map_size.x - 1 else draw_line
		for i: int in place.next_places.size():
			var next_point: Vector2 = nodes[place.next_places[i]].position
			var shrink: Vector2 = point.direction_to(next_point) * 8.0
			method.call(point + shrink, next_point - shrink, Palette.NIGHT[(3 if i == player_idx else 2) if place == Game.place else 1])


func _physics_process(_delta: float) -> void:
	player_idx = remap(player.position.y, Route.RECT.position.y, Route.RECT.end.y, 0.0, Game.place.next_places.size())
	queue_redraw()


func coords_to_point(coords: Vector2i) -> Vector2:
	var point: Vector2 = Vector2(coords.x + 1, coords.y) * SEPARATION
	return point + Vector2(sin(point.y), sin(point.x)) * 4.0
