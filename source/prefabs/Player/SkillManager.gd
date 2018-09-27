var parent
var director
var skillSceneNode

const CANCEL_COOLDOWN_TIME = 1.5

#Skill
var skills = {}
var currentSkill = null

#Skill nodes
var skillNodes = {}

var isCasting = false
var castTimer = 0
var castTimeValue = 0

var isAttacking = false
var attackTimer = 0
var attackTimeValue = 0

signal select_attack
signal attack_input
signal condition_hit

signal use_skill

signal attack_started
signal attack_finished
signal attack_cancelled
signal attack_disrupted

func _init(_parent, _director, _skillSceneNode):
	parent = _parent
	director = _director
	skillSceneNode = _skillSceneNode
	connect("attack_started",self, "attackStarted")
	connect("attack_cancelled",self,"attackCancelled")
	connect("attack_finished", self, "attackFinished")
	
	insertSkill("basic", "ability_wind_slash")
	insertSkillSceneNode("basic","ability_wind_slash")
	
	insertSkill("heavy", "barbaric_leap")
	#insertSkill("dodge", "lightning_dash")
	pass

func update(delta):
	updateSkillCooldowns(delta)
	updateCurrentSkillTimers(delta)
	pass

func updateSkillCooldowns(delta):
	for key in skills:
		var elem = skills[key]
		if elem.onCooldown:
			elem.cooldownTimer += delta
			if elem.cooldownTimer >= elem.currentCooldownTime:
				elem.onCooldown = false
				elem.cooldownTimer = 0

func updateCurrentSkillTimers(delta):
	if isCasting:
		castTimer += delta
		if castTimer >= castTimeValue:
			isCasting = false
			castTimer = 0
			isAttacking = true
			attackTimeValue = currentSkill.attackTime
			executeSkill(parent.global_transform.origin, parent.getTargetPositionByRayTrace(), currentSkill.attackTime)
			if skillNodes.has(currentSkill.assignedSkillSlot):
				skillNodes[currentSkill.assignedSkillSlot].start()

	if isAttacking:
		attackTimer += delta
		if attackTimer >= attackTimeValue:
			isAttacking = false
			attackTimer = 0
			if skillNodes.has(currentSkill.assignedSkillSlot):
				skillNodes[currentSkill.assignedSkillSlot].stop()

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

func useSkill(skillSlot):
	var skill = skills[skillSlot]
	currentSkill = skill
	if skill.onCooldown == false:
		if isCasting and skill.skillType == "dodge": #Allow to cancel with dodge skill
			cancelSkill()
			startCasting()
		elif isAttacking == false:
			startCasting()

func cancelSkill():
	if currentSkill == null or isAttacking:
		return
		
	if isCasting:
		isAttacking = false
		isCasting = false
		castTimer = 0
		castTimeValue = 0
		currentSkill.onCooldown = true
		currentSkill.currentCooldownTime = CANCEL_COOLDOWN_TIME

func startCasting():
	isCasting = true
	castTimeValue = currentSkill.castTime
	parent.startCasting(currentSkill.castName)
	pass
	
func executeSkill(_startPosition,_targetPoint, _attackTime):
	var targetData
	match currentSkill.inputType:
		"point":
			targetData = _targetPoint
		"direction":
			targetData = _targetPoint - _startPosition

	director.emit_signal("next_state", currentSkill.nextState,[_startPosition,targetData,_attackTime])
	pass