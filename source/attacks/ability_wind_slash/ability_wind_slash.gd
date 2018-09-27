extends "res://source/scripts/Skill.gd"

func _init():
	id = "ability_wind_slash"
	displayName = "Wind slash"
	skillType = "attack"
	assignedSkillSlot = null #The skill slot the skill is bound to

	#Animation data
	castName = "cast" #The player's casting animation
	castTime = 0.322
	
	initialDamage = 20 #This is the initial damage from a skill
	damageValues = [10,20,30] #For multi-damage attacks with varying damage values.
	
	attackTime = 1
	#Cooldown values
	onCooldown = false
	cooldownTimer = 0
	currentCooldownTime = 0
	defaultCooldownTime = 3 #The cooldown used after using a skill