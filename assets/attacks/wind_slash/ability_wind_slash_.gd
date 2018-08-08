extends "res://Ability.gd"
var damage = [30,40,50]

func _init().("Wind Slash", 1):
	pass

func attack():
	self.setOnCooldown()
	$AnimationPlayer.play("attack")
	pass