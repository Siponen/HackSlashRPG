extends KinematicBody

const MOVE_SPEED = 0.5

var camera
var upDirection = Vector3(0,1,0)

var viewport
var centerPosition

#Common Player AudioStreams
var loadedSounds = {}

#Player states
var loadedPlayerStates = {}
var currentPlayerState

var skillManager

#Debuffs
var isSilenced = false

#Animations
var animPlayer
var animTreePlayer

signal on_hit
signal on_play_sound

signal activate_skill
signal cancel_skill

signal set_player_state
signal set_default_state
signal player_state_finished
signal player_conditional_state_finished

signal player_basic_attack

func _ready():
	viewport = get_viewport()
	centerPosition = viewport.size*0.5
	camera = $Camera
	animPlayer = $AnimationPlayer
	animTreePlayer = $AnimationTreePlayer

	skillManager = preload("res://source/prefabs/Player/SkillManager.gd").new(self, $SkillSceneObjects)

	loadSounds()
	initStates()
	connectSignals()
	initPlayerCollision()
	pass

func loadSounds():
	loadedSounds["jump"] = load("res://assets/sound/sfx_movement_jump17.wav")
	loadedSounds["land"] = load("res://assets/sound/sfx_movement_jump17_landing.wav")
	loadedSounds["dash"] = load("res://assets/sound/sfx_movement_jump14.wav")
	loadedSounds["teleport"] = load("res://assets/sound/sfx_movement_portal1.wav")
	pass

func initStates():
	var defaultState = preload("res://source/scripts/EntityStates/PlayerDefaultState.gd").new(camera, viewport)
	addPlayerState("default", defaultState)
	
	var jumpState = preload("res://source/scripts/EntityStates/KinematicBodyJumpState.gd").new()
	addPlayerState("jump", jumpState)
	
	var dashState = preload("res://source/scripts/EntityStates/KinematicBodyDashState.gd").new()
	addPlayerState("dash", dashState)
	
	var teleportState = preload("res://source/scripts/EntityStates/KinematicBodyTeleportState.gd").new()
	addPlayerState("teleport", teleportState)
	
	var counterState = preload("res://source/scripts/EntityStates/KinematicBodyCounterState.gd").new()
	addPlayerState("counter", counterState)
	
	var blockState = preload("res://source/scripts/EntityStates/KinematicBodyBlockState.gd").new()
	addPlayerState("block", blockState)
	
	var inputJumpState = preload("res://source/scripts/EntityStates/DelayedInputJumpState.gd").new()
	addPlayerState("inputJump", inputJumpState)
	
	currentPlayerState = loadedPlayerStates["default"]
	pass

func connectSignals():
	connect("on_hit", self, "onHit")
	connect("on_play_sound", self, "onPlaySound")
	connect("activate_skill", self, "activateSkill")
	connect("cancel_skill", self, "cancelSkill")
	connect("set_player_state", self, "setPlayerState")
	connect("set_default_state", self, "setDefaultState")
	connect("player_state_finished", self, "playerStateFinished")
	connect("player_conditional_state_finished", self, "playerConditionalStateFinished")
	connect("player_basic_attack", self, "playerBasicAttack")
	connect("player_reset_attack", self, "playerResetBasicAttack")
	pass

func addPlayerState(stateKey, state):
	state.parent = self
	loadedPlayerStates[stateKey] = state
	pass

func initPlayerCollision():
	self.set_collision_layer_bit(PhysicsLayers.PLAYER_BODY_BIT, true)
	
	self.set_collision_mask_bit(PhysicsLayers.UNPASSABLE_GEOMETRY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.PASSABLE_GEOMETRY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.PLAYER_BODY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.ENEMY_BODY_BIT, true)
	self.set_collision_mask_bit(PhysicsLayers.ENEMY_DAMAGE_BIT, true)

func getTargetPositionByRayTrace():
	var rayLength = 1000
	var mousePos = viewport.get_mouse_position()
	var camera = $Camera
	var from = camera.project_ray_origin(mousePos)
	var to = from + camera.project_ray_normal(mousePos) * rayLength
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [self], PhysicsLayers.UNPASSABLE_GEOMETRY_VALUE)
	return result.position

# Update
func  _process(delta):
	currentPlayerState.update(delta)
	skillManager.update(delta)
	pass

# Physics
func _physics_process(delta):
	currentPlayerState.physics(delta)
	pass

func activateSkill(skillSlot):
	skillManager.startAttack(skillSlot)
	pass

func cancelSkill(skillSlot):
	skillManager.cancelSkill()
	pass

func setDefaultState():
	currentPlayerState.onExit()
	currentPlayerState = loadedPlayerStates["default"]
	currentPlayerState.onEnter()
	pass

func setPlayerState(skillStateData):
	currentPlayerState.onExit()
	currentPlayerState = loadedPlayerStates[skillStateData.stateId]
	currentPlayerState.onEnter(skillStateData)
	pass

# Signals
func onHit(onHitData):
	var health = $Health
	health.emit_signal("damage", onHitData.damage)
	pass
	
func onPlaySound(soundName):
	$AudioStreamPlayer.stream = loadedSounds[soundName]
	$AudioStreamPlayer.play()
	pass

func playerStateFinished():
	skillManager.emit_signal("next_skill_state")
	pass
	
func playerConditionalStateFinished(isSuccess):
	skillManager.emit_signal("next_conditional_skill_state", isSuccess)
	pass

func playerBasicAttack(basicSkillStateData):
	animPlayer.play(basicSkillStateData.entityAnimation)
	pass

func playerResetBasicAttack():
	animPlayer.play("basic_reset")
	pass