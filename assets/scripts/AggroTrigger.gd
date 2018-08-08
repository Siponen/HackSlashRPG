extends Area

var parent
var attack
var isAggroed = false
var targetBody = null
var aggroTimeLimit = 2
var aggroTimer
var aggroRange = 50
var attackRange = 5

func _ready():
	parent = get_parent()
	attack = get_node("../Attack")
	$CollisionShape.scale = Vector3(aggroRange,aggroRange,aggroRange)
	
	connect("body_entered",self,"onEnter")
	connect("body_exited",self,"onExit")
	pass

func _process(delta):
	if isAggroed: #Follow the player, and attack it
		#Behaviour state should be here, which we can swap between.
		var direction = (targetBody.global_transform.origin - global_transform.origin).normalized()
		parent.look_at(targetBody.global_transform.origin,Vector3(0,1,0))
		parent.move_and_collide(direction*parent.moveSpeed)
		
		#Within attack range
		if direction.length() < attackRange and attack.onCooldown == false:
			attack.attack()
		
	elif targetBody != null:
		aggroTimer += delta
		if aggroTimer > aggroTimeLimit:
			isAggroed = true
	pass

func onEnter(body):
	if targetBody == null:
		targetBody = body
		isAggroed = true
		print(parent.name, " is aggroed by ", body.name)
	pass

func onExit(body):
	if targetBody == body:
		targetBody = null
		isAggroed = false
		aggroTimer = 0
	pass