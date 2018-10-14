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
var patternDirector = preload("res://source/bosses/BossPatternDirector.gd").new()

#Scene nodes
var threatSystem

#Signals
signal next_state
signal trigger_aggro

func _ready():
	threatSystem = $ThreatSystem
	bossName = "Von Hundefutter"
	
	initSignals()
	initStates()
	initPatterns()
	pass

func initSignals():
	connect("on_hit", self, "onHit")
	connect("on_stun", self, "onStun")
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

func initPatterns():
	pass

func _process(delta):
	currentState.update(delta)
	if currentTarget != null:
		var distance = currentTarget.global_transform - self.global_transform.origin
		distance.y = 0
		var distanceLength = distance.length()
	
	
	
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
	#Do whatever
	pass

func onStun():
	#Do whatever
	pass

func onDeath():
	$DeathSound.play()
	pass

func onNextState(stateId):
	currentState.onExit()
	currentState = loadedStates[stateId]
	currentState.onEnter()
	pass

func triggerAggro(target):
	currentTarget = threatSystem.currentTarget.body
	onNextState("fight")
	pass