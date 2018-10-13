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
var damageIndex

var isActive
var targetsAlreadyHit = {}

signal start_hurtbox
signal end_hurtbox

func _ready():
	parent = get_parent()
	player = get_parent().get_parent().get_parent()
	isActive = false
	hide()
	pass

func _physics_process(delta):
	if isActive:
		var bodyArray = get_overlapping_bodies()
		for body in bodyArray:
			if targetsAlreadyHit.has(body.name): 
				continue
			body.health.emit_signal("on_damage", parent.damageArray[damageIndex])
			targetsAlreadyHit[body.name] = body
			print(player.name, " hurt ", body.name)
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