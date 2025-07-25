class_name Place

var type: PlaceType = preload("res://resources/place_type/default.tres")
var coords: Vector2i
var next_places: Array[Place]


func link(next_place: Place) -> void:
	var idx: int = next_places.bsearch_custom(next_place, sort_places)
	if idx == next_places.size() or next_places[idx] != next_place:
		next_places.insert(idx, next_place)


func unlink(next_place: Place) -> void:
	next_places.erase(next_place)


static func sort_places(a: Place, b: Place) -> bool:
	return a.coords < b.coords
