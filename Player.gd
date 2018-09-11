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

#Dodge state data
var dodgeStartPosition = Vector3()
var dodgeEndPosition = Vector3()

var playerMovementTime = 0.4
var playerCurrentMovementTime = 0

#PlayerMovement
var playerMovementVelocity = Vector2()

#Debuffs
var isSilenced = false

#Ability data
var Ability = preload("res://assets/scripts/Ability.gd")
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
	
	self.set_collision_layer_bit(PhysicsLayers.UNPASSABLE_GEOMETRY_BIT, true)
	self.set_collision_layer_bit(PhysicsLayers.PASSABLE_GEOMETRY_BIT, true)
	self.set_collision_layer_bit(PhysicsLayers.PLAYER_BODY_BIT, true)
	self.set_collision_layer_bit(PhysicsLayers.ENEMY_BODY_BIT, true)
	self.set_collision_layer_bit(PhysicsLayers.ENEMY_DAMAGE_BIT, true)
	
	self.set_collision_mask_bit(PhysicsLayers.UNPASSABLE_GEOMETRY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.PASSABLE_GEOMETRY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.PLAYER_BODY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.ENEMY_BODY_BIT, true)
	pass

func startDash(): #Dash
	print("Start dash")
	self.set_collision_layer_bit(PhysicsLayers.UNPASSABLE_GEOMETRY_BIT, true)
	self.set_collision_layer_bit(PhysicsLayers.PASSABLE_GEOMETRY_BIT, false)
	self.set_collision_layer_bit(PhysicsLayers.PLAYER_BODY_BIT, false)
	self.set_collision_layer_bit(PhysicsLayers.ENEMY_BODY_BIT, false)
	self.set_collision_layer_bit(PhysicsLayers.ENEMY_DAMAGE_BIT, false)
	
	self.set_collision_mask_bit(PhysicsLayers.UNPASSABLE_GEOMETRY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.PASSABLE_GEOMETRY_BIT, false)
	self.set_collision_mask_bit(PhysicsLayers.PLAYER_BODY_BIT, false)
	self.set_collision_mask_bit(PhysicsLayers.ENEMY_BODY_BIT, false)

func stopDash():
	print("Stop dash")
	self.set_collision_layer_bit(PhysicsLayers.UNPASSABLE_GEOMETRY_BIT, true)
	self.set_collision_layer_bit(PhysicsLayers.PASSABLE_GEOMETRY_BIT, true)
	self.set_collision_layer_bit(PhysicsLayers.PLAYER_BODY_BIT, true)
	self.set_collision_layer_bit(PhysicsLayers.ENEMY_BODY_BIT, true)
	self.set_collision_layer_bit(PhysicsLayers.ENEMY_DAMAGE_BIT, true)
	
	self.set_collision_mask_bit(PhysicsLayers.UNPASSABLE_GEOMETRY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.PASSABLE_GEOMETRY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.PLAYER_BODY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.ENEMY_BODY_BIT, true)

############
# Update
#############
func  _process(delta):
	setPlayerOrentation()
	var velocity = getPlayerMovementVelocity()
	playerMovementVelocity.x = velocity.x
	playerMovementVelocity.y = velocity.z
	
	#Debug stuff
	testPausingAnimations()
	
	#Evasive input, can always be transitioned into from other attacks
	if isSilenced == false:
		if Input.is_action_just_pressed("dodge"):
			if $AttackGroup.isAttacking: #Cancel any ongoing attacks and move into dodge
				$AttackGroup.currentAttack.cancel()
			
			var playerPosition = global_transform.origin
			var playerForward = global_transform.basis.x # TODO basis.z is somehow right-direction vector, while it should be forward. Related to rotation offset player's kinematic body
			playerForward.y = 0
			dodgeStartPosition = playerPosition
			dodgeEndPosition = playerPosition + playerForward * 30
			isPlayerInFixedMovement = true
			playerCurrentMovementTime = 0
			startDash()
			$AnimationPlayer.play("Dodge")
	
	#Ability input
	if isSilenced == false and $AttackGroup.isAttacking == false:
		if Input.is_action_pressed("attack"):
			if $AttackGroup/basic_attack.onCooldown == false:
				$AttackGroup/basic_attack.attack()
		
		if Input.is_action_just_pressed("heavy_attack"):
			if $AttackGroup/heavy_attack.onCooldown == false:
				$AttackGroup/heavy_attack.attack()
	pass

func testPausingAnimations():
	if Input.is_action_just_pressed("play_anim"):
		$AnimationPlayer.play("Attack")
		print("Test attack anim")
	elif Input.is_action_just_pressed("pause_anim"):
		$AnimationPlayer.stop(false)
		print("Pause anim")
	elif Input.is_action_just_pressed("unpause_anim"):
		$AnimationPlayer.play()
		print("Unpause anim")

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
	var midPositionX = lerp(dodgeStartPosition.x, dodgeEndPosition.x, percentProgress)
	var midPositionZ = lerp(dodgeStartPosition.z, dodgeEndPosition.z, percentProgress)
	
	var velocity = Vector3()
	velocity.x = midPositionX - playerPosition.x
	velocity.z = midPositionZ - playerPosition.z

	if playerCurrentMovementTime > playerMovementTime:
		isPlayerInFixedMovement = false
		stopDash()
		print("Done!", "End position: ", global_transform.origin)
		
	playerCurrentMovementTime += delta
	move_and_collide(velocity)

func physicsMovePlayer(delta):
	var velocity = Vector3()
	velocity.x = playerMovementVelocity.x
	velocity.z = playerMovementVelocity.y
	move_and_collide(velocity)
