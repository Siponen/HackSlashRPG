var parent
var director

#OnEnter data
var startPosition
var endPosition
var timeLimit

var timer = 0
var isActive = true
var yOffset = 2

func onEnter(onEnterData):
	startPosition = onEnterData[0]
	endPosition = onEnterData[1]
	timeLimit = onEnterData[2]
	
	timer = 0
	isActive = true
	parent.emit_signal("on_play_sound", "jump")
	pass

func onExit():
	isActive = false
	parent.scale = Vector3(1,1,1)
	parent.emit_signal("on_play_sound", "land")
	pass

func update(delta):
	if isActive:
		timer += delta
		if timer >= timeLimit:
			isActive = false
			director.emit_signal("next_state", null, null)
	pass

func physics(delta):
	if isActive:
		var parentPosition = parent.global_transform.origin
		parentPosition.y = 0
		print("ParentPoint ", parentPosition, "TargetPoint: ", endPosition)
		var midPoint = Vector3()
		var progressValue = timer / timeLimit
		midPoint.x = lerp(startPosition.x, endPosition.x, progressValue)
		midPoint.z = lerp(startPosition.z, endPosition.z, progressValue)
		
		var velocity = midPoint - parentPosition
		parent.move_and_collide(velocity)
	pass