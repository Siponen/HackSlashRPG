var parent
var director
var skillSceneNode

#Loaded skills
var skills = {}

#Current skill data
var currentSkill
var currentStateIndex = 0
var currentSkillState
var currentSkillStateArray = []

#Current Basic skill data
var currentBasicSkill
var currentBasicSkillState
var currentBasicSkillStateArray = []
var resetTimer = 0
var resetTimeValue = 0

#Skill Scene Nodes
var skillNodes = {}

#Casting
var isCasting = false
var castTimer = 0
var castTimeValue = 0

signal start_attack
signal next_skill_state
signal next_conditional_skill_state

func _init(_parent, _skillSceneNode):
	parent = _parent
	skillSceneNode = _skillSceneNode
	
	connect("start_attack", self, "startAttack")
	connect("next_skill_state", self, "nextSkillState")
	connect("next_conditional_skill_state", self, "nextConditionalSkillState")
	
	insertSkill("basic", "ability_wind_slash")
	insertSkillSceneNode("basic","ability_wind_slash")
	
	insertSkill("heavy", "barbaric_leap")
	insertSkill("dodge", "lightning_dash")
	insertSkill("slot_1", "teleport")
	insertSkill("slot_2", "counter_attack")
	pass

func insertSkill(skillSlot, skillName):
	var skillPath = "res://source/attacks/" + skillName + "/" + skillName + ".gd"
	var skill = load(skillPath).new()
	skill.assignedSkillSlot = skillSlot
	skills[skillSlot] = skill
	pass

func insertSkillSceneNode(skillSlot,skillName):
	var scenePath = "res://source/attacks/" + skillName + "/" + skillName + ".tscn"
	var sceneForSkill = load(scenePath).instance()
	sceneForSkill.name = skillSlot
	skillNodes[skillSlot] = sceneForSkill
	skillSceneNode.add_child(sceneForSkill)
	pass

func update(delta):
	updateSkillCooldowns(delta)
	
	if currentBasicSkill != null:
		currentBasicSkill.resetTime += delta
		if currentBasicSkill.resetTime > currentBasicSkill.resetTimeLimit:
			currentBasicSkill = null
			currentBasicSkillState = null
			currentBasicSkillStateArray = null
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
	var skill = skills[skillSlot]
	if skill.skillType == "basic": #An attack without affecting the player state
		if currentBasicSkill == null or currentBasicSkillStateArray.empty() or skill.id != currentBasicSkill.id:
			currentBasicSkill = skill
			currentBasicSkill.onBasicAttack = true
			currentBasicSkill.resetTime = 0
			currentBasicSkillStateArray = currentBasicSkill.skillData.duplicate()
			currentBasicSkillState = currentBasicSkillStateArray.pop_front()
			print(currentBasicSkillState)
			parent.emit_signal("player_basic_attack", currentBasicSkillState)
		else:
			currentBasicSkill.resetTime = 0
			currentBasicSkillState = currentBasicSkillStateArray.pop_front()
			
			print(currentBasicSkillState)
			parent.emit_signal("player_basic_attack", currentBasicSkillState)

	else: #An attack with its own player states
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