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
var player
var damageInstance = []

var isActive
var targetsAlreadyHit = {}

signal start_hurtbox
signal end_hurtbox

func _ready():
	parent = get_parent()
	isActive = false
	hide()
	pass

func _physics_process(delta):
	if isActive:
		var bodyArray = get_overlapping_bodies()
		for body in bodyArray:
			if targetsAlreadyHit.has(body.name): 
				continue
			body.health.emit_signal("on_damage", damageInstance)
			targetsAlreadyHit[body.name] = body
	pass

func addDamage(damage,type):
	damageInstance.append({"damage": damage, "damageType":type})
	pass

func onStartHurtbox():
	isActive = true
	set_collision_mask_bit(4,true)
	show()
	print("Start Area hurtbox")
	pass

func onEndHurtbox():
	isActive = false
	targetsAlreadyHit.clear()
	set_collision_mask_bit(4, false)
	hide()
	print("End Area hurtbox")
	pass