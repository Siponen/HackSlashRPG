var parent
var director

var timer

var startPosition
var targetPosition
var timeTaken

func onEnter(onEnterData): #[startPosition,targetPosition, timeTaken]
	print("Counter Start!")
	timer = 0
	startPosition = onEnterData[0]
	targetPosition = onEnterData[1]
	timeTaken = onEnterData[2]
	#parent.emit_signal("on_play_sound","dash")
	pass

func onExit():
	print("Counter Finished!")
	pass

func update(delta):
	pass

func physics(delta):
	var result = parent.move_and_collide(Vector3())
	if result != null:
		var collider = result.collider
		print("Counter collider: ", collider)
		director.emit_signal("next_state","dash", null)
		print("Counter Success")
		
	if timer > timeTaken: #Counter failed, go back to default state
		director.emit_signal("next_state",null, null)

	timer += delta
	pass