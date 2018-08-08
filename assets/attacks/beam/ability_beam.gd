extends "res://Ability.gd"

func _init().("Laser Beam", 1):
	pass

func _ready():
	pass

func attack():
	if onCooldown == false:
		self.setOnCooldown()
		$AnimationPlayer.play("attack")

func onCharge():
	$ChargeUp.play()
	pass

func onHit():
	$AttackSound.play()
	pass