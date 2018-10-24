var parent
var isAlive

var health
var maxHealth

var physicalResistance = 0
var magicResistance = 0

signal on_damage
signal on_death
signal on_heal

func _init(_parent, _hp, _maxHp):
	connect("on_damage",self,"onDamage")
	connect("on_death",self,"onDeath")

	parent = _parent
	isAlive = true
	health = _hp
	maxHealth = _maxHp
	pass

func onDamage(damageDataArray):
	var sumDamage = 0
	for damageData in damageDataArray:
		sumDamage += damageData.damage
		health -= damageData.damage

	if(health <= 0):
		onDeath()

	print(parent.name, " took ", sumDamage, " damage")
	parent.emit_signal("on_hit")
	pass

func onHeal(healPoints):
	health += healPoints
	pass

func onDeath():
	print(parent.name," dies")
	parent.emit_signal("on_death")
	pass

func onPoison():
	pass

func onBurn():
	pass

func onStun():
	pass

func onSilence():
	pass