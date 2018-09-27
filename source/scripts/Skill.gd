var id
var displayName
var assignedSkillSlot #The skill slot the skill is bound to

var inputType #point, direction, null
var skillType #dodge, dash, counter, block
var nextState #[Dash]
var attackRange

#Dodge data
var dodgeType #Teleport, Dash

#Animation data
var scenePath #The path to the scene object.

var initialDamage #This is the initial damage from a skill
var damageValues = [] #For multi-damage attacks with varying damage values.

#Casting values
var castName #The player's casting animation
var castTime 

#Attack values
var attackTime

#Cooldown values
var onCooldown
var cooldownTimer
var currentCooldownTime
var defaultCooldownTime #The cooldown used after using a skill

#StateSequence
var playerStates = []