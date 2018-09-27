var parent
var director

var timer
var timeTaken

var startPosition
var targetPosition

func onEnter(onEnterData): #[startPosition,targetPosition]
	timer = 0
	timeTaken = 0
	startPosition = onEnterData[0]
	targetPosition = onEnterData[1]
	activateDashCollisions()
	pass

func onExit():
	disableDashCollisions()
	pass

func update(delta):
	pass

func physics(delta):
	var playerPosition = parent.global_transform.origin
	var percentProgress = timer / timeTaken
	var midPositionX = lerp(startPosition.x, targetPosition.x, percentProgress)
	var midPositionZ = lerp(startPosition.z, targetPosition.z, percentProgress)
	
	var velocity = Vector3()
	velocity.x = midPositionX - playerPosition.x
	velocity.z = midPositionZ - playerPosition.z

	if timer > timeTaken:
		director.emit_signal("next_state", "default")

	timer += delta
	move_and_collide(velocity)
	
func disableDashCollisions():
	parent.set_collision_layer_bit(PhysicsLayers.PLAYER_BODY_BIT, true)
	
	parent.set_collision_mask_bit(PhysicsLayers.UNPASSABLE_GEOMETRY_BIT, true)
	parent.set_collision_mask_bit(PhysicsLayers.PASSABLE_GEOMETRY_BIT, true)
	parent.set_collision_mask_bit(PhysicsLayers.PLAYER_BODY_BIT, true)
	parent.set_collision_mask_bit(PhysicsLayers.ENEMY_BODY_BIT, true)
	parent.set_collision_mask_bit(PhysicsLayers.ENEMY_DAMAGE_BIT, true)
	
func activateDashCollisions():
	parent.set_collision_layer_bit(PhysicsLayers.PLAYER_BODY_BIT, false)
	
	parent.set_collision_mask_bit(PhysicsLayers.UNPASSABLE_GEOMETRY_BIT, true)
	parent.set_collision_mask_bit(PhysicsLayers.PASSABLE_GEOMETRY_BIT, false)
	parent.set_collision_mask_bit(PhysicsLayers.PLAYER_BODY_BIT, false)
	parent.set_collision_mask_bit(PhysicsLayers.ENEMY_BODY_BIT, false)
	parent.set_collision_mask_bit(PhysicsLayers.ENEMY_DAMAGE_BIT, false)