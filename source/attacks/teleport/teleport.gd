extends "res://source/scripts/Skill.gd"

func _init():
	id = "teleport"
	displayName = "Teleport"
	inputType = "point"
	skillType = "mobility"
	assignedSkillSlot = null #The skill slot the skill is bound to
	nextState = "teleport" #The player state change, after the final state change, it switches back to default state

	#Animation data
	castName = "cast" #The player's casting animation
	castTime = 0.2
	
	initialDamage = 20 #This is the initial damage from a skill
	damageValues = 100
	
	attackTime = 0.5
	#Cooldown values
	onCooldown = false
	cooldownTimer = 0
	currentCooldownTime = 0
	defaultCooldownTime = 3 #The cooldown used after using a skill