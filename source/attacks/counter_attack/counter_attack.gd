extends "res://source/scripts/Skill.gd"

func _init():
	id = "counter_attack"
	displayName = "Counter attack"
	skillType = "heavy"
	attackRange = 400
	assignedSkillSlot = null #The skill slot the skill is bound to
	
	#Cast data
	castName = "cast" #The player's casting animation
	castTime = 0.2

	#Cooldown values
	onCooldown = false
	cooldownTimer = 0
	currentCooldownTime = 0
	defaultCooldownTime = 3 #The cooldown used after using a skill

	skillData = [
		{
			"stateId": "counter",
			"entityAnimation": "counter",
			"spellSceneEffect": null,
			
			"onEnterCharacterSound": null,
			"onExitCharacterSound": null,
			
			"onEnterEffectSound": "jump",
			"onExitEffectSound": "land ",
			
			"attackTime": 2.5,
		},
		{ #Success skill state
			"stateId": "inputJump",
			"entityAnimation": "jump",
			"spellSceneEffect": null,
			
			"onEnterCharacterSound": null,
			"onExitCharacterSound": null,
			
			"onEnterEffectSound": "jump",
			"onExitEffectSound": "land ",
			
			"attackTime": 2.5,
			"damage": 100
		},
		{ #Fail skill state
			"stateId": "teleport",
			"entityAnimation": null,
			"spellSceneEffect": null,
			
			"onEnterCharacterSound": null,
			"onExitCharacterSound": null,
			
			"onEnterEffectSound": "teleport",
			"onExitEffectSound": "land ",
			
			"attackTime": 0.5,
		}, 
	]