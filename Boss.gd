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

#Bullets
var Bullet = preload("res://assets/prefabs/Bullet.tscn")

signal on_hit
signal on_stun
signal on_death

signal follow_player

var cooldown = 1
var timer = 0

func _ready():
	connect("is_damaged",self,"isDamaged")
	connect("on_hit", self, "onHit")
	connect("on_stun", self, "onStun")
	connect("on_death", self, "onDeath")
	pass

func _process(delta):
	#Threat
	#Decide upon nextAction
	timer += delta
	if timer > cooldown:
		shoot()
		timer = 0

func shoot():
	var direction = Vector3(1,0,0)
	
	var aBullet = Bullet.instance()
	aBullet.init(10,direction)
	$Bullets.add_child(aBullet)
	
	aBullet = Bullet.instance()
	direction = direction.rotated(Vector3(0,1,0), 0.25*PI)
	aBullet.init(10,direction)
	$Bullets.add_child(aBullet)
	
	aBullet = Bullet.instance()
	direction = direction.rotated(Vector3(0,1,0), 0.25*PI)
	aBullet.init(10,direction)
	$Bullets.add_child(aBullet)
	
	aBullet = Bullet.instance()
	direction = direction.rotated(Vector3(0,1,0), 0.25*PI)
	aBullet.init(10,direction)
	$Bullets.add_child(aBullet)
	
	aBullet = Bullet.instance()
	direction = direction.rotated(Vector3(0,1,0), 0.25*PI)
	aBullet.init(10,direction)
	$Bullets.add_child(aBullet)
	
	print("Boss Shoots!")
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