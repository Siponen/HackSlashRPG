extends KinematicBody

const MOVE_SPEED = 0.5

var camera
var upDirection = Vector3(0,1,0)
var currentAngle  = 0

var viewport
var centerPosition

var playerDodgePosition = Vector3()

#Debuffs
var isSilenced = false
var isAttacking = false

#Attacks
var attackCooldown = 0.5
var attackTimer = 0

var heavyAttackCooldown = 2.0
var heavyAttackTimer = 0

var ultimateAttackCooldown = 3
var ultimateAttackTimer = 0

#Ability data
var Ability = preload("res://Ability.gd")
var abilities = []
var ultimates = []

#Animations
var animPlayer
var animTreePlayer

#Weapon determines Weapon Basic Attack and Weapon Heavy Attack
#Some abilities are restricted to races, afflictions like werewolf and undead
#Some abilities can only be learned through factions or trainers

func _ready():
	camera = $Camera
	viewport = get_viewport()
	animPlayer = $AnimationPlayer
	animTreePlayer = $AnimationTreePlayer
	centerPosition = viewport.size*0.5
	
	var meleeBasicAttack = Ability.new("melee_basic_attack",10,0.8)
	abilities.append(meleeBasicAttack)
	
	var heavyAttack = Ability.new("heavy",20,1)
	abilities.append(heavyAttack)
	
	var counterAttack = Ability.new("counter",10,1)
	abilities.append(counterAttack)
	
	var shieldReflectAttack = Ability.new("shield_reflect",0,1)
	abilities.append(shieldReflectAttack)
	
	var ultimate = Ability.new("ultimate",100,1)
	ultimates.append(ultimate)
	pass

func  _process(delta):
	setPlayerOrentation()
	var velocity = getPlayerMovementVelocity()
	playerMovementVelocity.x = velocity.x
	playerMovementVelocity.y = velocity.z
	
	#Resolve cooldowns
	if attackTimer > 0:
		attackTimer -= delta
	if heavyAttackTimer > 0:
		heavyAttackTimer -= delta
	if ultimateAttackTimer > 0:
		ultimateAttackTimer -= delta
	
	#Dodge input
	if isSilenced == false:
		if Input.is_action_just_pressed("dodge"):
			print("Roll")
			var playerPosition = global_transform.origin
			var playerForward = global_transform.basis.z
			#playerDodgePosition.x = 
			
			playerCurrentDodgeTime = 1
			pass
		pass

	if playerCurrentDodgeTime > 0:
		#Lerp this
		playerCurrentDodgeTime -= delta
	
	#Attack input
	if isSilenced == false:
		if Input.is_action_just_pressed("attack"):
			if attackTimer <= 0:
				$basic_attack/AnimationPlayer.play("Attack")
				attackTimer = attackCooldown
				print("Player Attack")
		elif Input.is_action_just_pressed("heavy_attack"):
			if heavyAttackTimer <= 0:
				$heavy_attack/AnimationPlayer.play("Attack")
				heavyAttackTimer = heavyAttackCooldown
				print("Player Heavy Attack")
		elif Input.is_action_just_pressed("ultimate_attack"):
			if ultimateAttackTimer <= 0:
				animPlayer.play("Ultimate")
				ultimateAttackTimer = ultimateAttackCooldown
				print("Player Ultimate Attack")
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

func _physics_process(delta):
	physicsMovePlayer()
	pass

func physicsMovePlayer():
	var velocity = Vector3()
	velocity.x = playerMovementVelocity.x
	velocity.z = playerMovementVelocity.y
	
	# Add other physical forces on the player
	# TODO Add it here
	
	move_and_collide(velocity)