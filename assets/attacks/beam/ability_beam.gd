extends "res://assets/scripts/Ability.gd"

func _init().("Laser Beam", 1, 3):
	pass

func onCharge():
	$ChargeUp.play()
	pass

func onHit():
	$AttackSound.play()
	pass