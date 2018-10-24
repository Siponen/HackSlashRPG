extends Spatial
#Boss nodeTable
#Consists of behaviour states, leading from one to another over time.

#key - id
#{
#	name (and animName)
#	nextNodeId
#	timeToNextNode (in godot delta format)
#}

var parent
var nodeTable
var animPlayer
var audioPlayer

#Pattern data
var onCooldown = false
var cooldownTimer = 0
var defaultCooldown

var pausePoint = 0
var currentNode

#Meta data for Boss AI to make a decision on
var startNodeId
var minRange
var maxRange

signal on_start_pattern
signal on_next_node

func _init(_startNodeId, _minRange, _maxRange, _cooldownTime):
	connect("on_start_pattern", self, "onStartPattern")
	connect("on_next_node",self,"onNextNode")
	
	nodeTable = {}
	startNodeId = _startNodeId
	minRange = _minRange
	maxRange = _maxRange
	defaultCooldown = _cooldownTime
	pass

func _ready():
	parent = get_parent()
	animPlayer = $AnimationPlayer
	audioPlayer = $AudioStreamPlayer
	pass

func _process(delta):
	if onCooldown:
		cooldownTimer += delta
		if cooldownTimer >= defaultCooldown:
			onCooldown = false
			print("BossPattern REFRESHED")

func addNode(_name, _nextNodeId):
	var node = {"name": _name, "nextNodeId":_nextNodeId }
	nodeTable[_name] = node
	pass

func onStartPattern():
	currentNode = nodeTable[startNodeId]
	onNextNode()
	pass

func onNextNode():
	startAnimation(currentNode.name)
	print("BOSS ATTACKS ", currentNode.name)
	if currentNode.nextNodeId != null:
		finishPattern()
	else:
		currentNode = nodeTable[currentNode.nextNodeId]
		print("NEXT NODE ", currentNode.name)
		pass
	pass

func finishPattern():
	onCooldown = true
	cooldownTimer = 0
	parent.emit_signal("on_pattern_finished")
	print("BOSS PATTERN ON COOLDOWN")
	pass
	
func startAnimation(animName):
	animPlayer.play(animName)
	show()

func startFromPause():
	animPlayer.seek(pausePoint, true)
	animPlayer.play()
	show()
	pass

func pauseAnimation():
	pausePoint = animPlayer.current_animation_position
	animPlayer.stop()
	pass

func stopAnimation():
	animPlayer.stop()
	animPlayer.seek(0,true) #Resets the animation player to position 0. stop(true) doesnt do this
	hide()
	pass