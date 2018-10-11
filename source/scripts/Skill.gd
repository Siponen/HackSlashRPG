var id
var displayName
var skillType #dodge, dash, counter, block
var attackRange
var assignedSkillSlot #The skill slot the skill is bound to

#Casting values
var castName #The player's casting animation
var castTime 

#Basic attack
var onBasicAttack
var resetTime
var resetTimeLimit

#Cooldown values
var onCooldown
var cooldownTimer
var currentCooldownTime
var defaultCooldownTime #The cooldown used after using a skill

#SkillScript
var skillData = [] #Json datastructure for skill state data (Array with dictionary elements)

#[
#	{
#		stateId: counter,
#		entityAnimation: counter,
#		spellSceneEffect: null,
#		onEnterSound: block_sfx,
#		onExitSound: hah_sfx,
#		attackTime: 2.5,
#		damage: 100,
#	},
#	{
#		stateId: dash,
#		entityAnimation: dash_1
#	}
#]