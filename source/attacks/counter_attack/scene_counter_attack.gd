extends "res://source/scripts/SkillSceneScript.gd"

func _ready():
	$SuccessHurtbox.addDamage(50,"physical")
	$SuccessHurtbox2.addDamage(50,"physical")
	pass