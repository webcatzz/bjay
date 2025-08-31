func babble_halt() -> Dialogue:
	var dlg := Dialogue.new()
	dlg.speaker("Babble")
	if Game.data.get("babble_friendship", 0) < 2:
		dlg.say("Jay, er, did you want to talk about anything before you go?")
	elif Game.data["babble_friendship"] < 4:
		dlg.say("How was your flight, Jay?")
		dlg.say("Heaven knows there's not much going on here, oahaha!")
	else:
		dlg.say("Hey, not so fast, Jay! Stay a while.")
		dlg.say("What news from the front lines?")
	dlg.prompt({
		"(Present a photo.)": present_photo,
		"(Take off.)": take_off,
	})
	return dlg


func present_photo() -> void:
	pass


func take_off() -> void:
	pass
