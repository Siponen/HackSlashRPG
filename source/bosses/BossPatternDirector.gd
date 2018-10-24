extends Spatial

var parent
var patternArray = []

var isActive = false
var timer = 0
var actionsPerSecond = 0.5
var usingPattern = false
var usingPatternName = ""

signal on_pattern_finished

func _ready():
	connect("on_pattern_finished",self,"onPatternFinished")
	parent = get_parent()
	randomize()
	patternArray = get_children()
	pass

func _process(delta):
	#Look for next action to do
	if isActive:
		if not usingPattern:
			timer += delta
			if timer >= actionsPerSecond:
				timer -= actionsPerSecond
				tick()
	pass

func tick():
	if parent.currentTarget != null:
		var distance = parent.currentTarget.global_transform.origin - parent.global_transform.origin
		var nextPattern = getNextPattern(distance)
		if nextPattern != null:
			var sceneNode = findPattern(nextPattern)
			print("Find Scene node: ", sceneNode)
			if sceneNode != null:
				sceneNode.emit_signal("on_start_pattern")
				usingPattern = true
				usingPatternName = nextPattern.name
	pass

func onPatternFinished():
	usingPattern = false
	usingPatternName = ""
	pass

func findPattern(ourPattern):
	for pattern in patternArray:
		if pattern.name == ourPattern.name:
			return pattern
		pass

	return {}

func getNextPattern(_targetDistance):
	var desiredPatterns = []
	#Get patternArray in boss's range to player unit
	for pattern in patternArray:
		#if pattern.onCooldown == false and _targetDistance >= pattern.minRange and _targetDistance <= pattern.maxRange:
		if not pattern.onCooldown:
			desiredPatterns.append(pattern)
			print("Pattern is not on cooldown")
		else:
			print("Pattern is on cooldown")
	#Determine which pattern to select
	var selectedPattern
	var numPatterns = desiredPatterns.size()
	print("Desired patterns:" , numPatterns)
	if numPatterns == 0:
		selectedPattern = null
		pass
	elif numPatterns > 1: #Randomize one pattern
		var patternIndex = randi() % numPatterns
		selectedPattern = desiredPatterns[patternIndex]
		pass
	else:
		selectedPattern = desiredPatterns.front()
		print("Selected pattern: ", selectedPattern)
		pass

	return selectedPattern