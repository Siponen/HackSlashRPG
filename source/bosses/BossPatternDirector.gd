var BossPattern = preload("res://source/bosses/BossPattern.gd")

var patternCategory = {}

var activePattern = {}
var activeNode = {}

func _init():
	randomize()
	pass

func addCategory(_categoryId):
	patternCategory[_categoryId] = []
	pass

func addPattern(_categoryId, _patternObject):
	var patternArray = patternCategory[_categoryId]
	patternArray.append(_patternObject)
	pass

func getPattern(_categoryId, _targetDistance):
	var patternArray = patternCategory[_categoryId]
	var desiredPatterns = []
	
	#Get patterns in boss's range to player unit
	for pattern in patternArray:
		if _targetDistance >= pattern.minRange and _targetDistance <= pattern.maxRange:
			desiredPatterns.append(pattern)
	
	#Determine which pattern to select
	var selectedPattern
	var numPatterns = desiredPatterns.size()
	if numPatterns == 0:
		selectedPattern = {} #Nothing
		pass
	elif numPatterns > 1: #Randomize one pattern
		var patternIndex = randi() % numPatterns
		selectedPattern = desiredPatterns[patternIndex]
		pass
	else:
		selectedPattern = desiredPatterns.first()
		pass

	return selectedPattern

func setActivePattern(_patternObject):
	activePattern = _patternObject
	activeNode = activePattern.startNode
	pass
	
func nextNode():
	var nextNode = activePattern.pattern[activeNode.nextNodeId]
	setActivePattern(nextNode)
	pass