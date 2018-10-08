var parent
var isAlive

var health
var maxHealth

signal damage
signal death
signal heal

func _init(_parent, _hp):
	parent = _parent
	isAlive = true
	health = _hp
	maxHealth = _hp
	
	connect("damage",self,"onDamage")
	connect("death",self,"onDeath")
	pass

func onDamage(damage):
	health -= damage
	parent.emit_signal("on_damage")
	print(parent.name," takes Damage ",damage, " has ", health, " hp")
	
	if(health <= 0):
		onDeath()
	pass

func onHeal(healPoints):
	health += healPoints
	pass
	
func onDeath():
	parent.emit_signal("on_death")
	print(parent.name," dies")
	pass
	
func onPoison():
	pass

func onBurn():
	pass

func onStun():
	pass
	
func onSilence():
	pass