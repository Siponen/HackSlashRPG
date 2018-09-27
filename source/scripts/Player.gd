extends KinematicBody

const MOVE_SPEED = 0.5

var camera
var upDirection = Vector3(0,1,0)

var viewport
var centerPosition

#Common Player AudioStreams
var loadedSounds = {}

#Debuffs
var isSilenced = false

#Animations
var animPlayer
var animTreePlayer

var stateDirector
var skillManager

signal on_hit
signal on_play_sound
signal activate_skill
signal cancel_skill

func _ready():
	viewport = get_viewport()
	centerPosition = viewport.size*0.5
	camera = $Camera
	animPlayer = $AnimationPlayer
	animTreePlayer = $AnimationTreePlayer
	
	loadedSounds["jump"] = load("res://assets/sound/sfx_movement_jump17.wav")
	loadedSounds["land"] = load("res://assets/sound/sfx_movement_jump17_landing.wav")
	loadedSounds["dash"] = load("res://assets/sound/sfx_movement_jump14.wav")
	loadedSounds["teleport"] = load("res://assets/sound/sfx_movement_portal1.wav")
	
	stateDirector = preload("res://source/scripts/StateDirector/StateDirector.gd").new(self)
	skillManager = preload("res://source/prefabs/Player/SkillManager.gd").new(self, stateDirector, $SkillSceneObjects)
	
	var defaultState = preload("res://source/scripts/StateDirector/PlayerDefaultState.gd").new(camera, viewport)
	stateDirector.addState("default", defaultState)
	
	var jumpState = preload("res://source/scripts/StateDirector/KinematicBodyJumpState.gd").new()
	stateDirector.addState("jump", jumpState)
	
	var dashState = preload("res://source/scripts/StateDirector/KinematicBodyDashState.gd").new()
	stateDirector.addState("dash", dashState)
	
	var teleportState = preload("res://source/scripts/StateDirector/KinematicBodyTeleportState.gd").new()
	stateDirector.addState("teleport", teleportState)
	
	var counterState = preload("res://source/scripts/StateDirector/KinematicBodyCounterState.gd").new()
	stateDirector.addState("counter", counterState)
	
	var blockState = preload("res://source/scripts/StateDirector/KinematicBodyBlockState.gd").new()
	stateDirector.addState("block", blockState)
	
	stateDirector.setActive("default")
	
	connect("on_hit", self, "onHit")
	connect("on_play_sound", self, "onPlaySound")
	connect("activate_skill", self, "activateSkill")
	connect("cancel_skill", self, "cancelSkill")
	
	initPlayerCollision()
	pass

func activateSkill(skillSlot):
	skillManager.useSkill(skillSlot)
	pass

func initPlayerCollision():
	self.set_collision_layer_bit(PhysicsLayers.PLAYER_BODY_BIT, true)
	
	self.set_collision_mask_bit(PhysicsLayers.UNPASSABLE_GEOMETRY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.PASSABLE_GEOMETRY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.PLAYER_BODY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.ENEMY_BODY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.ENEMY_DAMAGE_BIT, true)

func startCasting(animName):
	animPlayer.play(animName)
	pass

func getTargetPositionByRayTrace():
	var rayLength = 1000
	var mousePos = viewport.get_mouse_position()
	var camera = $Camera
	var from = camera.project_ray_origin(mousePos)
	var to = from + camera.project_ray_normal(mousePos) * rayLength
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [self], PhysicsLayers.UNPASSABLE_GEOMETRY_VALUE)
	return result.position

##############
# Update
##############
func  _process(delta):
	skillManager.update(delta)
	stateDirector.update(delta)
	pass

##############
# Physics
##############
func _physics_process(delta):
	stateDirector.physics(delta)
	pass

#############
# Signals
#############
# Hitdata: Damage, DamageType, OnHitEffect
func onHit(onHitData):
	var health = $Health
	health.emit_signal("damage", onHitData.damage)
	pass
	
func onPlaySound(soundName):
	$AudioStreamPlayer.stream = loadedSounds[soundName]
	$AudioStreamPlayer.play()
	pass

func cancelSkill(skillSlot):
	skillManager.cancelSkill()
	pass