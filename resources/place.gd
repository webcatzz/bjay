class_name Place

var type: PlaceType = preload("res://resources/place_type/default.tres")
var coords: Vector2i
var next_places: Array[Place]
var prev_places: Array[Place]


func link(next_place: Place) -> void:
	next_places.append(next_place)
	next_place.prev_places.append(self)


func unlink(next_place: Place) -> void:
	next_places.erase(next_place)
	next_place.prev_places.erase(self)
