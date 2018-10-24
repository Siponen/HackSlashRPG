extends "res://source/bosses/BossPattern.gd"

func _init().("attack1",500,750, 5): 
	addNode("attack1", "attack2")
	addNode("attack2", "attack3")
	addNode("attack3", "")
	pass

func _ready():
	$Hurtbox.addDamage(20,"magic")
	$Hurtbox2.addDamage(20,"magic")
	$Hurtbox3.addDamage(20,"magic")
	pass
