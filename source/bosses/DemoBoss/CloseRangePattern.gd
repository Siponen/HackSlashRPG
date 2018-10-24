extends "res://source/bosses/BossPattern.gd"

func _init().("first_attack"):
	minRange = 100
	maxRange = 200
	addNode("first_attack", "First Attack", "ability_wind_slash", "second_attack")
	addNode("second_attack", "Second Attack", "ability_wind_slash", "third_attack")
	addNode("third_attack", "Third Attack", "ability_wind_slash", null)
	pass