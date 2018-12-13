var parent
var skillManager

var assignedDevice # M&K, [Gamepads] 1,2,3,4,5,6...20

var onRecovery = false
var recoveryTime = 0
var recoveryTimeLimit = 0

var camera
var upDirection = Vector3(0,1,0)
var currentAngle  = 0

var viewport
var centerPosition

var isHoldingAttack = false

const SPEED = 40
const ACCELERATION = 10
const DE_ACCELERATION = 10
var velocity = Vector3()
var gravity = -100
var isWalking = false

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
	
	#Pressed logic
	if Input.is_action_just_pressed("dodge"):
		parent.emit_signal("activate_skill", "dodge")

	elif Input.is_action_just_pressed("cancel"):
		parent.emit_signal("cancel_skill","cancel")

	elif Input.is_action_just_pressed("attack"): #Toggable attack
		isHoldingAttack = true
		parent.emit_signal("activate_skill","basic")

	elif isHoldingAttack: #Do this
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

	#Unpressed logic
	if Input.is_action_just_released("attack"):
		isHoldingAttack = false
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
	var cameraForward = camera.global_transform.basis.z
	var cameraLeft = camera.global_transform.basis.x
	
	var direction = Vector3()
	if Input.is_action_pressed("move_up"):
		direction -= cameraForward
	elif Input.is_action_pressed("move_down"):
		direction += cameraForward

	if Input.is_action_pressed("move_left"):
		direction -= cameraLeft
	elif Input.is_action_pressed("move_right"):
		direction += cameraLeft

	direction.y = 0
	return direction.normalized()

func physics(delta):
	var walkDirection = getPlayerMovementVelocity()
	if walkDirection.length() > 0 and isWalking == false: #Start running
		isWalking = true
		parent.startRunning()
	elif walkDirection.length() == 0 and isWalking == true: #Stop running
		isWalking = false
		parent.stopRunning()
	
	velocity.y += delta * gravity
	var hv = velocity
	hv.y = 0
	var new_pos = walkDirection * SPEED
	var accel = DE_ACCELERATION
	
	if (walkDirection.dot(hv) > 0):
		accel = ACCELERATION
	hv = hv.linear_interpolate(new_pos, accel * delta)
	
	velocity.x = hv.x
	velocity.z = hv.z
	velocity = parent.move_and_slide(velocity, Vector3(0,1,0))