extends Node

var animPlayer
var isAlive
var parent
var health
var maxHealth

signal damage
signal death
signal heal

func _ready():
	isAlive = true
	connect("damage",self,"onDamage")
	connect("death",self,"onDeath")
	parent = get_parent()
	animPlayer = parent.get_node("AnimationPlayer")
	health = 100
	pass

func onDamage(damage):
	health -= damage
	animPlayer.play("Hurt")
	print(parent.name," takes Damage ",damage, " has ", health, " hp")
	
	if(health <= 0):
		emit_signal("death")
		parent.emit_signal("on_death")
	pass

func onHeal(healPoints):
	health += healPoints
	pass

func onDeath():
	animPlayer.play("Death")
	print(parent.name," dies")
	pass