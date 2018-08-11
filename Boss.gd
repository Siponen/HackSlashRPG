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

#Threat signals
signal threat_deals_damage
signal threat_is_healing

#Action Queue
#StayAtRange, Chase(Point,Walk/Run), Attack(Body,AttackName), RunAwayFrom(Body), Defend(Body)
var nextAction
var currentAction

signal on_hit
signal on_stun
signal on_death

signal follow_player

var cooldown = 1
var timer = 0

func _ready():
	#connect("is_damaged",self,"isDamaged")
	connect("on_hit", self, "onHit")
	connect("on_stun", self, "onStun")
	connect("on_death", self, "onDeath")
	pass

func _process(delta):
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