extends Area

var parent

#Threat decreases when
#Someone runs away
#Someone blocks attack
#Boss misses attack

#Threat increases when
#Someone uses Taunt ability
#Someone uses Healing ability
#Someone deals damage

#Threat may increase A LOT when
#Someone has low hp
#Someone is using estus

#Threat is removed when it reaches ThreatValue 0

#Threat Decay
const INITIAL_THREAT = 1000
const THREAT_DECAY_PER_SECOND = 100

var threatList = [] # Value:{ThreatValue, isActiveInBattle, Body}  Player/Companions/Minions, ThreatValue
var numThreats = 0

var currentTarget = {}

signal threat_deals_damage
signal threat_is_healing

func _ready():
	parent = get_parent()
	connect("body_entered",self,"onBodyEnter")
	connect("body_exited",self,"onBodyExit")
	pass

func addThreat(body):
	if threatList.empty():
		currentTarget = body
		threatList.append({"name":body.name, "threatValue": INITIAL_THREAT, "isActiveInBattle": true ,"body": body})
		numThreats += 1
	pass

func removeThreat(body):
	for i in range(numThreats):
		var threat = threatList[i]
		if threat.name == body.name:
			removeThreatAt(i)
	pass

func removeThreatAt(index):
	threatList.remove(index)
	numThreats -= 1
	pass

func update(delta):
	if threatList.size > 1:
		#First step - Threat Decay, and remove at zero threat points
		updateThreatValuesFirstStep(delta) 
	
		# TODO Re-evaluate the path cost to the top threats.
		threatList.sort_custom(ThreatSorter,"sort")
		currentTarget = threatList[0]
	pass

func updateThreatValuesFirstStep(delta):
	for i in range(numThreats):
		var threat = threatList[i]
		threat.threatValue -= THREAT_DECAY_PER_SECOND*delta
		
		if threat.threatValue <= 0:
			removeThreatAt(i)
	pass

func isBodyInThreatList(body):
	for threat in threatList:
		if threat.name == body.name:
			return false
	return true

func onBodyEnter(body):
	if numThreats == 0:
		addThreat(body)
		currentTarget = threatList[0]
		parent.emit_signal("trigger_aggro",currentTarget)
	else:
		if not isBodyInThreatList(body):
			addThreat(body)
	pass

func onBodyExit(body):
	for threat in threatList:
		if threat.name == body.name:
			threat.isActiveInBattle = false
	pass

class ThreatSorter:
	static func sort(a, b):
		if a[0].threatValue < b[0].threatValue:
			return true
		else:
			return false