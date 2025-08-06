extends Node

const PLACE_WEIGHTS: Dictionary[String, float] = {
	droplet = 1.0,
	heat = 1.0,
	bird = 0.75,
	glass = 0.75,
	lightning = 0.25,
}

var origin := Place.new()
var destination := Place.new()
var size := Vector2i(5, 3)

var _grid: Dictionary[Vector2i, Place]
var _rng := RandomNumberGenerator.new()


func generate() -> void:
	Game.place = origin
	origin.next_places.clear()
	_grid.clear()
	# paths
	_add_place(origin, Vector2i(-1, size.y / 2))
	_add_place(destination, Vector2i(size.x, size.y / 2))
	for i: int in 3:
		var coords: Vector2i = origin.coords
		while coords.x < size.x - 1:
			var prev_place: Place = _get_place(coords)
			coords = _branch(coords)
			var next_place: Place = _get_place(coords)
			prev_place.link(next_place)
		_grid[coords].link(destination)
	# place types
	for x: int in size.x:
		for y: int in size.y:
			var place: Place = _grid.get(Vector2i(x, y))
			if place:
				var weights: Dictionary[String, float] = PLACE_WEIGHTS.duplicate()
				for prev_y: int in size.y:
					var prev_place: Place = _grid.get(Vector2i(place.coords.x - 1, prev_y))
					if prev_place and place in prev_place.next_places:
						weights.erase(prev_place.type.resource_path.get_file().get_slice(".", 0))
				place.type = load("res://resources/place_type/%s.tres" % weights.keys()[_rng.rand_weighted(weights.values())])


func places() -> Array[Place]:
	return _grid.values()


# paths

func _add_place(place: Place, coords: Vector2i) -> void:
	place.coords = coords
	_grid[coords] = place


func _get_place(coords: Vector2i) -> Place:
	if not coords in _grid:
		_add_place(Place.new(), coords)
	return _grid[coords]


func _branch(coords: Vector2i) -> Vector2i:
	var branches: PackedInt32Array = [0]
	for branch: int in [-1, 1]:
		if coords.y + branch >= 0 and coords.y + branch < size.y and not _is_linked(Vector2i(coords.x, coords.y + branch), Vector2i(coords.x + 1, coords.y)):
			branches.append(branch)
	return Vector2i(coords.x + 1, coords.y + branches[randi_range(0, branches.size() - 1)])


func _is_linked(start_coords: Vector2i, end_coords: Vector2i) -> bool:
	if start_coords in _grid:
		for next_place: Place in _grid[start_coords].next_places:
			if next_place.coords == end_coords:
				return true
	return false
