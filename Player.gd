extends KinematicBody

const MOVE_SPEED = 0.5

var camera
var upDirection = Vector3(0,1,0)
var currentAngle  = 0

var viewport
var centerPosition

var playerDodgePosition = Vector3()

#PlayerStates
var isPlayerInFixedMovement = false
var readyToAttack = true
var playerNewPosition = Vector3()
var playerMovementTime = 0.4
var playerCurrentMovementTime = 0

#PlayerMovement
var playerMovementVelocity = Vector2()

#Debuffs
var isSilenced = false
var isAttacking = false

#Ability data
var Ability = preload("res://Ability.gd")
var abilities = []
var ultimates = []

#Animations
var animPlayer
var animTreePlayer

func _ready():
	camera = $Camera
	viewport = get_viewport()
	animPlayer = $AnimationPlayer
	animTreePlayer = $AnimationTreePlayer
	centerPosition = viewport.size*0.5
	pass

############
# Update
#############

func  _process(delta):
	setPlayerOrentation()
	var velocity = getPlayerMovementVelocity()
	playerMovementVelocity.x = velocity.x
	playerMovementVelocity.y = velocity.z
	
	#Evasive input, can always be transitioned into from other attacks
	if isSilenced == false:
		if Input.is_action_just_pressed("dodge"):
			var playerPosition = global_transform.origin
			var playerForward = global_transform.basis.z # TODO basis.z is somehow right-direction vector, while it should be forward. Related to rotation of player's kinematic body
			playerForward.y = 0
			playerNewPosition = playerPosition + playerForward * 30;
			isPlayerInFixedMovement = true
			playerCurrentMovementTime = 0
			$AnimationPlayer.play("Dodge")
	
	#Ability input
	if isSilenced == false and readyToAttack:
		if Input.is_action_pressed("attack"):
			if $Abilities/basic_attack.onCooldown == false:
				$Abilities/basic_attack.attack()
		
		if Input.is_action_just_pressed("heavy_attack"):
			if $Abilities/heavy_attack.onCooldown == false:
				$Abilities/heavy_attack.attack()
	pass

func setPlayerOrentation():
	var mousePosition = viewport.get_mouse_position()
	var desiredDir = (mousePosition - centerPosition)
	var angle = atan2(desiredDir.y, desiredDir.x)
	
	if angle < 0:
		angle = 2*PI + angle
		
	var rotationMatrix = global_transform.basis.rotated(upDirection, -currentAngle) #Reset to angle 0, to then much more easily rotate to the correct angle
	var rotateAngle = -angle  #Apply negative angle, otherwise we rotate in wrong direction
	rotationMatrix = rotationMatrix.rotated(upDirection, rotateAngle)
	currentAngle = rotateAngle 
	global_transform.basis = rotationMatrix
	pass

func getPlayerMovementVelocity():
	var cameraForward = camera.global_transform.basis.z.normalized()
	var cameraLeft = camera.global_transform.basis.x.normalized()

	var velocity = Vector3()
	if Input.is_action_pressed("move_up"):
		velocity -= cameraForward * MOVE_SPEED
	elif Input.is_action_pressed("move_down"):
		velocity += cameraForward * MOVE_SPEED

	if Input.is_action_pressed("move_left"):
		velocity -= cameraLeft * MOVE_SPEED
	elif Input.is_action_pressed("move_right"):
		velocity += cameraLeft * MOVE_SPEED

	return velocity

##############
# Physics
##############
func _physics_process(delta):
	if isPlayerInFixedMovement:
		physicsFixedMovePlayer(delta)
	else:
		physicsMovePlayer(delta)
	pass

func physicsFixedMovePlayer(delta):
	var playerPosition = global_transform.origin
	var percentProgress = playerCurrentMovementTime / playerMovementTime
	var nextPositionX = lerp(playerPosition.x, playerNewPosition.x, percentProgress)
	var nextPositionZ = lerp(playerPosition.z, playerNewPosition.z, percentProgress)
	
	var velocity = Vector3()
	velocity.x = nextPositionX - playerPosition.x
	velocity.z = nextPositionZ - playerPosition.z
		
	if playerCurrentMovementTime > playerMovementTime:
		isPlayerInFixedMovement = false
		print("Done!", "End position: ", global_transform.origin)
		
	playerCurrentMovementTime += delta
	move_and_collide(velocity)

func physicsMovePlayer(delta):
	var velocity = Vector3()
	velocity.x = playerMovementVelocity.x
	velocity.z = playerMovementVelocity.y
	move_and_collide(velocity)
