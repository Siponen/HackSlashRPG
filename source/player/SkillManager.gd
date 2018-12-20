var parent
var director
var skillSceneNode

#Loaded skills
var skills = {}

#Skill Scene Nodes
var skillNodes = {}

#Current skill data
var currentSkill
var currentStateIndex = 0
var currentSkillState
var currentSkillStateArray = []

var currentSkillTimer = 0
var currentSkillTasks

#Current Basic skill data
var currentBasicSkill
var currentBasicSkillState
var currentBasicSkillStateArray = []
var resetTimer = 0
var resetTimeValue = 0

#Casting
var isCasting = false
var castTimer = 0
var castTimeValue = 0

#Attacking
var isAttacking = false
var attackIndex = 0
var attackTimer = 0
var attackTimeValue

signal start_attack
signal next_skill_state
signal next_conditional_skill_state

signal start_skill_animation

func _init(_parent, _skillSceneNode):
	parent = _parent
	skillSceneNode = _skillSceneNode
	
	connect("start_attack", self, "startAttack")
	connect("start_skill_animation", self, "startSkillAnimation")
	connect("next_skill_state", self, "nextSkillState")
	connect("next_conditional_skill_state", self, "nextConditionalSkillState")
	
	insertSkill("basic", "ability_wind_slash")
	insertSkill("heavy", "barbaric_leap")
	#insertSkill("dodge", "lightning_dash")
	#insertSkill("slot_1", "teleport")
	insertSkill("slot_2", "counter_attack")
	pass

func insertSkill(skillSlot, skillId):
	var skillPath = "res://source/attacks/" + skillId + "/" + skillId + ".gd"
	var skill = load(skillPath).new()
	skill.assignedSkillSlot = skillSlot
	skills[skillSlot] = skill
	
	var scenePath = "res://source/attacks/" + skillId + "/" + skillId + ".tscn"
	var sceneForSkill = load(scenePath).instance()
	print(sceneForSkill)
	sceneForSkill.name = skillSlot
	skillNodes[skillSlot] = sceneForSkill
	skillSceneNode.add_child(sceneForSkill)
	
	#Set initial data for different SkillScene types
	var index = 1
	var numSceneSteps = skill.sceneSteps
	if numSceneSteps > 1: #This SkillScene type, goes through a SkillScene on multiple attack commands like basic attacks
		sceneForSkill.setSteps(numSceneSteps)
		for skillState in skill.skillData:
			sceneForSkill.addDamage(skillState.damageInstance)
	else: #This SkillScene type goes through a SkillScene on one attack command
		for skillState in skill.skillData:
			if skillState.damageInstance != null:
				sceneForSkill.addDamage(skillState.damageInstance)
	pass

func update(delta):
	updateSkillCooldowns(delta)
	
	if isAttacking: #Stop us from starting an attack too early
		attackTimer += delta
		if attackTimer > attackTimeValue:
			isAttacking = false
	
	if currentBasicSkill != null:
		currentBasicSkill.resetTime += delta
		if currentBasicSkill.resetTime > currentBasicSkill.resetTimeLimit: #Stop condition for basic attack
			currentBasicSkill = null
			currentBasicSkillState = null
			currentBasicSkillStateArray = null
			attackIndex = 1 #Resets to lowest attack index
	pass

func updateSkillCooldowns(delta):
	for key in skills:
		var elem = skills[key]
		if elem.onCooldown:
			elem.cooldownTimer += delta
			if elem.cooldownTimer >= elem.currentCooldownTime:
				elem.onCooldown = false
				elem.cooldownTimer = 0

func startAttack(skillSlot):
	if not skills.has(skillSlot): 
		return

	var skill = skills[skillSlot]
	if skill.skillType == "basic": #An attack without affecting the player state
		if not isAttacking:
			executeBasicSkill(skill)
	else: #An attack with its own player states
		if not isAttacking:
			executeSkill(skill)
	pass

func startSkillAnimation(animName):
	var skillNode = skillNodes[currentSkill.assignedSkillSlot]
	skillNode.start(animName)
	pass

func executeBasicSkill(skill):
	#Initial basic skill execution
	if currentBasicSkill == null or currentBasicSkillStateArray.empty() or skill.id != currentBasicSkill.id:
		currentBasicSkill = skill
		currentBasicSkill.onBasicAttack = true
		currentBasicSkill.resetTime = 0
		currentBasicSkillStateArray = currentBasicSkill.skillData.duplicate()
		currentBasicSkillState = currentBasicSkillStateArray.pop_front()
		
		isAttacking = true
		attackIndex = 1
		attackTimer = 0
		attackTimeValue = currentBasicSkillState.attackTime
		parent.emit_signal("player_basic_attack", currentBasicSkillState)
		#skillNodes[skill.assignedSkillSlot].start("attack"+str(attackIndex))
		skillNodes[skill.assignedSkillSlot].start(currentBasicSkillState.onEnterSceneAnimation)
		print("Initial Player uses ", "attack"+str(attackIndex))
	#Non initial basic skill execution
	else:
		currentBasicSkill.resetTime = 0
		currentBasicSkillState = currentBasicSkillStateArray.pop_front()
		isAttacking = true
		attackTimer = 0
		attackIndex += 1
		attackTimeValue = currentBasicSkillState.attackTime
		parent.emit_signal("player_basic_attack", currentBasicSkillState)
		#skillNodes[skill.assignedSkillSlot].start("attack"+str(attackIndex))
		skillNodes[skill.assignedSkillSlot].start(currentBasicSkillState.onEnterSceneAnimation)
		print("Player uses ", "attack"+str(attackIndex))

func executeSkill(skill):
	currentSkill = skill
	currentSkillStateArray = currentSkill.skillData.duplicate() #Copy the skillData array so that we aren't mutating the skeleton skillData in skills
	currentSkillState = currentSkillStateArray.pop_front()
	parent.emit_signal("set_player_state", currentSkillState)
	pass

func nextSkillState():
	if currentSkillStateArray.empty():
		finishSkill()
	else:
		currentSkillState = currentSkillStateArray.pop_front()
		parent.emit_signal("set_player_state", currentSkillState)
	pass

func nextConditionalSkillState(isSuccess):
	if currentSkillStateArray.empty():
		finishSkill()
		pass
	
	if isSuccess:
		currentSkillState = currentSkillStateArray.pop_front() #Take the success state
		currentSkillStateArray.pop_front() #Ignore the fail state
		print("Success set next taste!")
	else:
		currentSkillStateArray.pop_front() #Ignore the success state
		currentSkillState = currentSkillStateArray.pop_front() #Take the fail state
		
	parent.emit_signal("set_player_state", currentSkillState)
	pass

func finishSkill():
	currentSkill.onCooldown = true
	currentSkill.cooldownTimer = 0
	currentSkill.currentCooldownTime = currentSkill.defaultCooldownTime
	parent.emit_signal("set_default_state")
	pass