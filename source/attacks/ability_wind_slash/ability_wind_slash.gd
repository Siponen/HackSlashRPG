extends "res://source/scripts/Skill.gd"

func _init():
	id = "ability_wind_slash"
	displayName = "Wind Slash"
	skillType = "basic"
	attackRange = 400
	assignedSkillSlot = null #The skill slot the skill is bound to
	
	#Cast data
	castName = "cast" #The player's casting animation
	castTime = 0.3

	#Cooldown values
	onCooldown = false
	cooldownTimer = 0
	currentCooldownTime = 0
	defaultCooldownTime = 1 #The cooldown used after using a skill

	skillData = [
		{
			"stateId": "default",
			"entityAnimation": "attack",
			"spellSceneEffect": "attack_effect",
			
			"onEnterCharacterSound": null,
			"onExitCharacterSound": null,
			
			"onEnterEffectSound": "hit_1",
			"onExitEffectSound": null,
			
			"attackTime": 1.5,
			"damage": 100
		},
	]