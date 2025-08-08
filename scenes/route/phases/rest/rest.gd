extends Phase


func _ready() -> void:
	var repair: int = randi_range(2, 4)
	Game.health += repair
	$Background/VBox/RepairAmount.text = "+%d hp" % repair
