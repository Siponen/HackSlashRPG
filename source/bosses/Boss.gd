extends KinematicBody

#Action Queue
#StayAtRange, Chase(Point,Walk/Run), Attack(Body,Distance,AttackName), Evade(Body), Defend(Body), RunAway(Body)

#When StayAtRange - Wait for cooldowns or Kite player
#Chase - To get into position for an attack / Combo

var currentState = {}
var loadedStates = {}

#Boss data
var bossName
var currentTarget
var cooldown = 1
var timer = 0
var walkSpeed = 4

#Boss modules
var health = preload("res://source/scripts/Health.gd").new(self, 100,100)
var threatSystem

#Signals
signal next_state
signal trigger_aggro

signal on_hit
signal on_death
signal on_stun

var loadedSounds = {}

func _ready():
	threatSystem = $ThreatSystem
	bossName = "Von Hundefutter"
	
	initSignals()
	initStates()
	initSounds()
	pass

func initSignals():
	connect("on_hit", self, "onHit")
	connect("on_stun", self, "onStun")
	connect("on_death", self, "onDeath")
	connect("next_state", self, "onNextState")
	connect("trigger_aggro", self, "triggerAggro")
	pass

func initStates():
	var idleState = preload("res://source/enemies/IdleState.gd").new(self)
	addBossState("idle", idleState)
	
	var chaseState = preload("res://source/enemies/ChaseState.gd").new(self)
	addBossState("fight", chaseState)
	
	currentState = loadedStates["idle"]
	pass

func initSounds():
	addSound("onHit","res://assets/sound/sfx_damage_hit2.wav")
	addSound("onDeath", "res://assets/sound/sfx_deathscream_alien1.wav")
	pass

func addSound(soundName, soundFile):
	loadedSounds[soundName] = load(soundFile)
	pass

func _process(delta):
	currentState.update(delta)
	if currentTarget != null:
		var distance = currentTarget.global_transform.origin - self.global_transform.origin
		distance.y = 0
		var distanceLength = distance.length()
		pass
	
	#Choose a skill that can reach that far away.
	#If not take the longest reach ability and use it when we get close enough.
	pass

func _physics_process(delta):
	currentState.physics(delta)
	pass

func addBossState(stateId,state):
	loadedStates[stateId] = state
	pass

func onHit():
	#$AudioStreamPlayer.stream = loadedSounds["onHit"]
	#$AudioStreamPlayer.play()
	pass

func onStun():
	#Do whatever
	pass

func onDeath():
	$AudioStreamPlayer.stream = loadedSounds["onDeath"]
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("Death")
	yield($AnimationPlayer, "animation_finished")
	$PatternDirector.free()
	set_process(false)
	set_physics_process(false)
	pass

func onNextState(stateId):
	currentState.onExit()
	currentState = loadedStates[stateId]
	currentState.onEnter()
	pass

func triggerAggro(target):
	currentTarget = threatSystem.currentTarget.body
	$PatternDirector.isActive = true
	onNextState("fight")
	pass