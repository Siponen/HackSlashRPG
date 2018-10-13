extends Area

#Damage, DamageType. A hurtbox can deal multiple damage instances at a time. Like Lightning Damage / Blunt Damage
#Blunt - Better against armor, stone, bone, crystal etc enemies.
#Edged - Better against unarmored enemies, to slice through organic matter.
#Elemental type - Strong against weak resistance, doesn't care if enemy is armored or unarmored.

#DamageData
#[
#	{"damage": 50, "damageType": "Lightning"},
#	{"damage": 50, "damageType": "Blunt"}
#]
var parent
var isActive

var timeToTick = 0.5

var damageDataArray = []
var bodiesInArea = {} #Key: Name, {DotTimer, body}

var hasInitialDamage = false
var initialDamage = []
var debuffModifiers = []

signal start_hurtbox
signal end_hurtbox

func _ready():
	parent = get_parent().get_parent() #Super ugly
	isActive = false
	hide()
	
	connect("body_entered", self, "onBodyEnter")
	connect("body_exited", self, "onBodyExit")
	pass

func setDamageData(_damageDataArray):
	damageDataArray = _damageDataArray
	pass

func _process(delta):
	for i in bodiesInArea:
		var body = bodiesInArea[i]
		body.timer += delta
		if body.timer > timeToTick:
			body.timer -= timeToTick
			body.body.health.emit_signal("on_damage", damageDataArray)
	pass

func onStartHurtbox():
	isActive = true
	set_collision_layer_bit(5,true)
	set_collision_mask_bit(5,true)
	show()
	print("Start Area hurtbox")
	pass

func onEndHurtbox():
	isActive = false
	targetsAlreadyHit.clear()
	set_collision_layer_bit(5,false)
	set_collision_mask_bit(5, false)
	hide()
	print("End Area hurtbox")
	pass

func onBodyEnter(body):
	if hasInitialDamage:
		body.health.emit_signal("on_damage", initialDamageArray)
	
	bodiesInArea[body.name] = {"body": body, "timer": 0}
	pass

func onBodyExit(body):
	bodiesInArea[body.name] = null
	pass