extends "res://source/scripts/StatefulSkillSceneScript.gd"

func _ready():
	$FirstSwingHurtBox.addDamage(10,"physical")
	$SecondSwingHurtBox.addDamage(10,"physical")
	$ThirdSwingHurtBox.addDamage(10,"physical")
	pass