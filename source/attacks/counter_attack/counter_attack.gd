extends "res://source/scripts/Skill.gd"

func _init():
	id = "counter_attack"
	displayName = "Counter attack"
	skillType = "heavy"
	attackRange = 400
	sceneSteps = 1
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
			
			"onEnterEffectSound": null,
			"onExitEffectSound": null,
			
			"onEnterSceneAnimation": null,
			"onExitSceneAnimation": null,
			
			"attackTime": 1.0,
			"damageInstance": [{"damage": 100, "damageType": "blunt"}]
		},
		{ #Success
			"stateId": "inputJump",
			"entityAnimation": "jump",
			
			"onEnterCharacterSound": "",
			"onExitCharacterSound": "",
			
			"onEnterEffectSound": "explode",
			"onExitEffectSound": "explode",
			
			"onEnterSceneAnimation": "attack_success",
			"onExitSceneAnimation": "attack_success2",
			
			"attackTime": 0.5,
			"damageInstance": [{"damage": 100, "damageType": "blunt"}]
		},
		{ #Fail state
			"stateId": "teleport",
			"entityAnimation": "",
			
			"onEnterCharacterSound": "",
			"onExitCharacterSound": "",
			
			"onEnterEffectSound": "explode",
			"onExitEffectSound": "",
			
			"onEnterSceneAnimation": "",
			"onExitSceneAnimation": "",
			
			"attackTime": 0.3,
			"damageInstance": [{"damage": 100, "damageType": "blunt"}]
		},
	]