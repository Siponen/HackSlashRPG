#Boss pattern
#Consists of behaviour states, leading from one to another over time.

#key - id
#{
#	name
#	skillName
#	nextNodeId
#	timeToNextNode (in godot delta format)
#}

var pattern
var startNodeId

#Meta data for Boss AI to make a decision on
var minRange
var maxRange

func new(_startNodeId):
	pattern = {}
	startNodeId = _startNodeId
	pass

func addNode(_keyId, _name, _skillName, _nextNodeId ,_timeToNextNode ):
	var node = {"name": _name, "skillName": _skillName, "nextNodeId":_nextNodeId }
	pattern[_keyId] = node
	pass

func clear():
	pattern.clear()
	pass