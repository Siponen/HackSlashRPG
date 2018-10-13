extends "res://source/scripts/StatefulSkillSceneScript.gd"

func _ready():
	$FirstSwingHurtBox.damageIndex = 0
	$SecondSwingHurtBox.damageIndex = 1
	$ThirdSwingHurtBox.damageIndex = 2
	pass