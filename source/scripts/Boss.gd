extends KinematicBody

#Threat decreases when
#Someone runs away
#Someone blocks attack
#Boss misses attack

#Threat increases when
#Someone uses Taunt ability
#Someone uses Healing ability
#Someone deals damage

#Threat may increase A LOT when
#Someone has low hp
#Someone is using estus
var threatList = [] # Player/Companions/Minions, ThreatValue
var currentTarget

#Action Queue
#StayAtRange, Chase(Point,Walk/Run), Attack(Body,Distance,AttackName), Evade(Body), Defend(Body), RunAway(Body)

#When StayAtRange - Wait for cooldowns or Kite player
#Chase - To get into position for an attack / Combo

var currentState = {}
var loadedStates = {}

#Health
var health = preload("res://source/scripts/Health.gd").new(self, 100,100)

#Threat signals
signal threat_deals_damage
signal threat_is_healing

signal on_hit
signal on_stun
signal on_death
signal drop_items

signal follow_player

#State signals
signal next_state

var bossName
var cooldown = 1
var timer = 0

var walkSpeed = 4

#Abilities
onready var doomBarrage = $Abilities/doom_barrage

func _ready():
	bossName = "Von Hundefutter"
	connect("on_hit", self, "onHit")
	connect("on_stun", self, "onStun")
	connect("next_state", self, "onNextState")
	
	var idleState = preload("res://source/enemies/IdleState.gd").new(self)
	addBossState("idle", idleState)
	
	var chaseState = preload("res://source/enemies/ChaseState.gd").new(self)
	addBossState("chase", chaseState)
	
	currentState = loadedStates["idle"]
	pass

func _process(delta):
	currentState.update(delta)
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

func onTrigger():
	onNextState("chase")
	pass

func onNextState(stateId):
	currentState.onExit()
	currentState = loadedStates[stateId]
	currentState.onEnter()
	pass