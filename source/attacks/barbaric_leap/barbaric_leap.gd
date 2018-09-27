extends "res://source/scripts/Skill.gd"

func _init():
	id = "barbaric_leap"
	displayName = "Barbaric Leap"
	inputType = "point"
	skillType = "heavy"
	assignedSkillSlot = null #The skill slot the skill is bound to
	nextState = "jump" #The player state change, after the final state change, it switches back to default state

	#Animation data
	castName = "cast" #The player's casting animation
	castTime = 0.322
	
	initialDamage = 20 #This is the initial damage from a skill
	damageValues = 100
	
	attackTime = 1
	#Cooldown values
	onCooldown = false
	cooldownTimer = 0
	currentCooldownTime = 0
	defaultCooldownTime = 3 #The cooldown used after using a skill