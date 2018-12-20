const IS_DONE = true
const IS_NOT_DONE = false

var targetKinematicBody
var positions= []

var currentStartPosition
var currentDestination

var timer = 0
var timeToNextPoint

var index = 0
var numSegments = 2

var yOffset = 5

func _init(body, targetPosition, takesTime):
	targetKinematicBody = body
	positions[0] = body.global_transform.origin #Start position
	
	var midPoint = Vector3()
	midPoint.x = targetPosition.x - positions[0].x
	midPoint.z = targetPosition.z - positions[0].z
	
	if targetPosition.y >= startPosition.y:
		midPoint.y = targetPosition.y + yOffset
	else:
		midPoint.y = startPosition.y + yOffset
	
	positions[1] = midPoint
	positions[2] = targetPosition
	
	timer = 0
	timeToNextPoint = takesTime*0.5
	pass

func update(delta):
	timer += delta
	if timer >= timeToNextPoint:
		index += 1
		timer = 0
		if index >= numSegments:
			onExit()
			return IS_DONE

	return IS_NOT_DONE

func physics(delta):
	velocity = Vector3()
	velocity.x = lerp(positions[index].x, positions[index+1].x, timer / timeToNextPoint)
	velocity.y = lerp(positions[index].y, positions[index+1].y, timer / timeToNextPoint)
	velocity.z = lerp(positions[index].z, positions[index+1].z, timer / timeToNextPoint)
	targetKinematicBody.move_and_collide(velocity)

func onEnter():
	targetKinematicBody.emit_signal("onPlaySound", "sfx_movement_jump17.wav")

func onExit():
	targetKinematicBody.scale = Vector3(1,1,1)
	targetKinematicBody.emit_signal("onPlaySound", "sfx_movement_jump17_landing.wav")
	pass