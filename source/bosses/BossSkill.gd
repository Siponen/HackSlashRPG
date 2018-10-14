var parent

var isCasting = false
var castTimer = 0
var castTimeValue

var cooldownTimer = 0
var cooldownTimeValue
var cancelCooldownTimeValue = 0
var baseCooldownTimeValue
var skillData

func _init(_parent, _filePath):
	parent = _parent
	skillData = loadSkillScript(_filePath)
	castTimeValue = skillData.castTime
	baseCooldownTimeValue = skillData.defaultCooldownTime
	pass

func loadSkillScript(filePath):
	return load(filePath).instance()

func update(delta):
	if isCasting:
		castTimer += delta
		if castTimer > castTimeValue:
			castTimer = 0
			startSkill()
	pass

func castSkill():
	isCasting = true
	parent.emit_signal("start_casting","")
	pass

func cancelCast():
	isCasting = false
	castTimer = 0
	cooldownTimeValue
	pass

func startSkill():
	pass
	
func endSkill():
	pass