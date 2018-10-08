extends "res://source/scripts/Skill.gd"

func _init():
	id = "lightning_dash"
	displayName = "Lightning dash"
	skillType = "mobility"
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
			"stateId": "dash",
			"entityAnimation": "dash",
			"spellSceneEffect": null,
			"onEnterCharacterSound": null,
			"onExitCharacterSound": null,
			"onEnterEffectSound": "dash",
			"onExitEffectSound": null,
			"attackTime": 0.7,
			"damage": 100
		},
	]