extends "res://source/scripts/Skill.gd"

func _init():
	id = "barbaric_leap"
	displayName = "Barbaric Leap"
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
			"stateId": "jump",
			"entityAnimation": "jump",
			
			"onEnterCharacterSound": "",
			"onExitCharacterSound": "",
			
			"onEnterEffectSound": "jump",
			"onExitEffectSound": "land",
			
			"onEnterSceneAnimation": "",
			"onExitSceneAnimation": "attack",
			
			"attackTime": 0.7,
			"damageInstance": [{"damage": 50, "damageType": "blunt"}]
		},
	]