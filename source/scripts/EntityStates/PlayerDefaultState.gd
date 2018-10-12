var parent
var assignedDevice # M&K, [Gamepads] 1,2,3,4,5,6...20

var onRecovery = false
var recoveryTime = 0
var recoveryTimeLimit = 0

var camera
var upDirection = Vector3(0,1,0)
var currentAngle  = 0

var viewport
var centerPosition

func _init(_camera, _viewport):
	camera = _camera
	viewport = _viewport
	centerPosition = viewport.size*0.5
	pass

func onEnter():
	pass

func onExit():
	pass

func update(delta):
	setPlayerOrentation()
	if not (parent.isSilenced and parent.onRecovery):
		if Input.is_action_just_pressed("dodge"):
			parent.emit_signal("activate_skill", "dodge")
		
		elif Input.is_action_just_pressed("cancel"):
			parent.emit_signal("cancel_skill","cancel")
			
		elif Input.is_action_just_pressed("attack"): #Attack should be toggable
			parent.emit_signal("activate_skill","basic")
			
		elif Input.is_action_just_pressed("heavy_attack"):
			parent.emit_signal("activate_skill","heavy")
			
		elif Input.is_action_just_pressed("counter_attack"):
			parent.emit_signal("activate_skill","counter")
			
		elif Input.is_action_just_pressed("slot_1"):
			parent.emit_signal("activate_skill","slot_1")
			
		elif Input.is_action_just_pressed("slot_2"):
			parent.emit_signal("activate_skill", "slot_2")
			
		elif Input.is_action_just_pressed("slot_3"):
			parent.emit_signal("activate_skill", "slot_3")
	pass

func setPlayerOrentation():
	var mousePosition = viewport.get_mouse_position()
	var desiredDir = (mousePosition - centerPosition)
	var angle = atan2(desiredDir.y, desiredDir.x)
	
	if angle < 0:
		angle = 2*PI + angle
		
	var rotationMatrix = parent.global_transform.basis.rotated(upDirection, -currentAngle) #Reset to angle 0, to then much more easily rotate to the correct angle
	var rotateAngle = -angle  #Apply negative angle, otherwise we rotate in wrong direction
	rotationMatrix = rotationMatrix.rotated(upDirection, rotateAngle)
	currentAngle = rotateAngle 
	parent.global_transform.basis = rotationMatrix
	pass

func getPlayerMovementVelocity():
	var cameraForward = camera.global_transform.basis.z.normalized()
	var cameraLeft = camera.global_transform.basis.x.normalized()

	var velocity = Vector3()
	if Input.is_action_pressed("move_up"):
		velocity -= cameraForward * parent.MOVE_SPEED
	elif Input.is_action_pressed("move_down"):
		velocity += cameraForward * parent.MOVE_SPEED

	if Input.is_action_pressed("move_left"):
		velocity -= cameraLeft * parent.MOVE_SPEED
	elif Input.is_action_pressed("move_right"):
		velocity += cameraLeft * parent.MOVE_SPEED

	return velocity

func physics(delta):
	var velocity = getPlayerMovementVelocity()
	velocity.y = 0
	parent.move_and_collide(velocity)