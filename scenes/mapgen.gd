extends RefCounted

const PLACE_WEIGHTS: Dictionary[String, float] = {
	default = 0.5,
	#sun = 1.0,
	#clouds = 1.0,
	rain = 0.75,
	storm = 0.15,
}

var grid: Dictionary[Vector2i, Place]
var size := Vector2i(5, 3)
var rng := RandomNumberGenerator.new()


func generate(start: Place, end: Place) -> Array[Place]:
	_add_place(start, Vector2i(-1, size.y / 2))
	_add_place(end, Vector2i(size.x, size.y / 2))
	# path generation
	for i: int in 3:
		var coords: Vector2i = start.coords
		while coords.x < size.x - 1:
			var prev_place: Place = _get_place(coords)
			coords = _branch(coords)
			var next_place: Place = _get_place(coords)
			if next_place not in prev_place.next_places:
				prev_place.link(next_place)
		if not _is_linked(coords, end.coords):
			grid[coords].link(end)
	# link sorting
	for place: Place in grid.values():
		place.next_places.sort_custom(_sort_links)
	return grid.values()


# places

func _get_place(coords: Vector2i) -> Place:
	if not coords in grid: _add_place(_generate_place(), coords)
	return grid[coords]


func _add_place(place: Place, coords: Vector2i) -> void:
	place.coords = coords
	grid[coords] = place


func _generate_place() -> Place:
	var place := Place.new()
	place.type = load("res://resources/place_type/%s.tres" % PLACE_WEIGHTS.keys()[rng.rand_weighted(PLACE_WEIGHTS.values())])
	return place


# links

func _sort_links(a: Place, b: Place) -> bool:
	return a.coords.y < b.coords.y


# branches

func _branch(coords: Vector2i) -> Vector2i:
	var branches: PackedInt32Array = [0]
	for branch: int in [-1, 1]:
		if coords.y + branch >= 0 and coords.y + branch < size.y and not _is_linked(Vector2i(coords.x, coords.y + branch), Vector2i(coords.x + 1, coords.y)):
			branches.append(branch)
	return Vector2i(coords.x + 1, coords.y + branches[randi_range(0, branches.size() - 1)])


func _is_linked(start_coords: Vector2i, end_coords: Vector2i) -> bool:
	if start_coords in grid:
		for next_place: Place in grid[start_coords].next_places:
			if next_place.coords == end_coords:
				return true
	return false
