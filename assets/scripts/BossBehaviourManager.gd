var behaviourMap = {}
var currentBehaviour = null

var targetList = []

func AddTarget(targetNode):
	targetList.append(targetNode)
	pass

func AddBehaviourNode(name, _behaviourNode):
	behaviourMap[name] = _behaviourNode
	pass

func SetCurrentBehaviour(name):
	if behaviourMap.has(name):
		currentBehaviour = behaviourMap[name]
	pass

func Update(delta):
	
	pass