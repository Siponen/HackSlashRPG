var parent

#OnEnter data
var startPosition
var peakHeight
var endPosition
var timeLimit

var timer = 0
var isActive = true
var yOffset = 20

var onEnterCharacterSound
var onExitCharacterSound

var onEnterEffectSound
var onExitEffectSound

var onEnterSceneAnimation
var onExitSceneAnimation

func onEnter(stateData):
	startPosition = parent.global_transform.origin
	endPosition = parent.getTargetPositionByRayTrace()
	timeLimit = stateData.attackTime
	
	onEnterCharacterSound = stateData.onEnterCharacterSound
	onExitCharacterSound = stateData.onExitCharacterSound
	
	onEnterEffectSound = stateData.onEnterEffectSound
	onExitEffectSound = stateData.onExitEffectSound
	
	onEnterSceneAnimation = stateData.onEnterSceneAnimation
	onExitSceneAnimation = stateData.onExitSceneAnimation
	
	if startPosition.y > endPosition.y:
		peakHeight = startPosition.y + yOffset
	else:
		peakHeight = endPosition.y + yOffset
	
	timer = 0
	isActive = true
	activateJumpCollisions()
	
	if not onEnterCharacterSound.empty():
		parent.emit_signal("on_play_sound", onEnterCharacterSound)
	
	if not onEnterEffectSound.empty():
		parent.emit_signal("on_play_sound", onEnterEffectSound)
	pass

func onExit():
	isActive = false
	parent.scale = Vector3(1,1,1)
	disableJumpCollisions()
	
	if not onExitCharacterSound.empty():
		parent.emit_signal("on_play_sound", onExitCharacterSound)
	
	if not onExitEffectSound.empty():
		parent.emit_signal("on_play_sound", onExitEffectSound)
	
	if not onExitSceneAnimation.empty():
		parent.skillManager.emit_signal("start_skill_animation", onExitSceneAnimation)
	pass

func update(delta):
	if isActive:
		timer += delta
		if timer >= timeLimit:
			isActive = false
			parent.emit_signal("player_state_finished")
	pass

func physics(delta):
	if isActive:
		var parentPosition = parent.global_transform.origin
		var midPoint = Vector3()
		var progressValue = timer / timeLimit
		
		midPoint.x = lerp(startPosition.x, endPosition.x, progressValue)
		
		if progressValue < 0.5:
			midPoint.y = lerp(startPosition.y, peakHeight, progressValue)
		else:
			midPoint.y = lerp(peakHeight, endPosition.y, progressValue)
			
		midPoint.z = lerp(startPosition.z, endPosition.z, progressValue)
		
		var velocity = midPoint - parentPosition
		parent.move_and_collide(velocity)
	pass
	
func disableJumpCollisions():
	parent.set_collision_layer_bit(PhysicsLayers.PLAYER_BODY_BIT, true)
	
	parent.set_collision_mask_bit(PhysicsLayers.UNPASSABLE_GEOMETRY_BIT, true)
	parent.set_collision_mask_bit(PhysicsLayers.PASSABLE_GEOMETRY_BIT, true)
	parent.set_collision_mask_bit(PhysicsLayers.PLAYER_BODY_BIT, true)
	parent.set_collision_mask_bit(PhysicsLayers.ENEMY_BODY_BIT, true)
	parent.set_collision_mask_bit(PhysicsLayers.ENEMY_DAMAGE_BIT, true)
	
func activateJumpCollisions():
	parent.set_collision_layer_bit(PhysicsLayers.PLAYER_BODY_BIT, false)
	
	parent.set_collision_mask_bit(PhysicsLayers.UNPASSABLE_GEOMETRY_BIT, true)
	parent.set_collision_mask_bit(PhysicsLayers.PASSABLE_GEOMETRY_BIT, false)
	parent.set_collision_mask_bit(PhysicsLayers.PLAYER_BODY_BIT, false)
	parent.set_collision_mask_bit(PhysicsLayers.ENEMY_BODY_BIT, false)
	parent.set_collision_mask_bit(PhysicsLayers.ENEMY_DAMAGE_BIT, false)