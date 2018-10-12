extends "res://source/scripts/Skill.gd"

func _init():
	id = "ability_wind_slash"
	displayName = "Wind Slash"
	skillType = "basic"
	attackRange = 400
	assignedSkillSlot = null #The skill slot the skill is bound to
	
	#Cast data
	castName = "cast" #The player's casting animation
	castTime = 0.2

	#Basic attack data
	onBasicAttack = false
	resetTime = 0
	resetTimeLimit = 0.5

	#Cooldown values
	onCooldown = false
	cooldownTimer = 0
	currentCooldownTime = 0
	defaultCooldownTime = 1 #The cooldown used after using a skill

	skillData = [
		{
			"entityAnimation": "attack1",
			"onExitEntityAnimation": "fallback",
			"spellSceneEffect": "attack_effect",
			
			"onEnterCharacterSound": null,
			"onExitCharacterSound": null,
			
			"onEnterEffectSound": "hit_1",
			"onExitEffectSound": null,
			
			"attackTime": 0.3,
			"damage": 30,
		},
		{
			"entityAnimation": "attack2",
			"onExitEntityAnimation": "fallback",
			"spellSceneEffect": "attack_effect",
			
			"onEnterCharacterSound": null,
			"onExitCharacterSound": null,
			
			"onEnterEffectSound": "hit_1",
			"onExitEffectSound": null,
			
			"attackTime": 0.3,
			"damage": 30
		},
		{
			"entityAnimation": "attack3",
			"onExitEntityAnimation": "fallback",
			"spellSceneEffect": "attack_effect",
			
			"onEnterCharacterSound": null,
			"onExitCharacterSound": null,
			
			"onEnterEffectSound": "hit_1",
			"onExitEffectSound": null,
			
			"attackTime": 0.3,
			"damage": 30
		},
	]