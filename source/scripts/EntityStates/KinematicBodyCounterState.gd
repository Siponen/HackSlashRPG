var parent

var timer
var startPosition
var targetPosition
var timeTaken

func onEnter(skillStateData): #[startPosition,targetPosition, timeTaken]
	print("Counter Start!")
	timer = 0
	startPosition = parent.global_transform.origin
	targetPosition = parent.getTargetPositionByRayTrace()
	timeTaken = skillStateData.attackTime
	pass

func onExit():
	pass

func update(delta):
	pass

func physics(delta):
	var result = parent.move_and_collide(Vector3())
	if result != null:
		var collider = result.collider
		print("Counter collider: ", collider)
		parent.emit_signal("player_conditional_state_finished", true)
		print("Counter Success")
		
	if timer > timeTaken: #Counter failed, go back to default state
		parent.emit_signal("player_conditional_state_finished", false)

	timer += delta
	pass