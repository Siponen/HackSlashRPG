extends "res://source/scripts/Skill.gd"

func _init():
	id = "barbaric_leap"
	displayName = "Barbaric Leap"
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
			"stateId": "jump",
			"entityAnimation": "jump",
			"spellSceneEffect": null,
			
			"onEnterCharacterSound": null,
			"onExitCharacterSound": null,
			
			"onEnterEffectSound": "jump",
			"onExitEffectSound": "land ",
			
			"attackTime": 1.5,
			"damage": 100
		},
	]