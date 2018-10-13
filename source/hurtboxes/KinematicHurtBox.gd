extends KinematicBody

#Damage, DamageType. A hurtbox can deal multiple damage instances at a time. Like Lightning Damage / Blunt Damage
#Blunt - Better against armor, stone, bone, crystal etc enemies.
#Edged - Better against unarmored enemies, to slice through organic matter.
#Elemental type - Strong against weak resistance, doesn't care if enemy is armored or unarmored.

#DamageData
#[
#	{"damage": 50, "damageType": "Lightning"},
#	{"damage": 50, "damageType": "Blunt"}
#]

#The kinematic body can not be non solid. And thus at times it can push kinematic bodies away, downwards or upwards.
#Fixes: Extend kinematic body with non-solid, or look to Areas

var parent
var damageDataArray = []
var targetsAlreadyHit = {}
var isActive = true

func setDamageData(_damageDataArray):
	damageDataArray = _damageDataArray
	pass

func _ready():
	parent = get_parent().get_parent() #A bit dirty, needs modification if structure changes
	hide()
	pass

func _physics_process(delta):
	self.transform.origin = Vector3(2,0,0)
	#global_transform.basis.z = parent.global_transform.basis.z
	if isActive:
		var result = move_and_collide(Vector3())
		#var result = move_and_collide(Vector3(),true,true) Use when 3.1 becomes available
		
		if result != null:
			var collider = result.collider
			print(parent.name, " hurt ", collider.name)
			collider.health.emit_signal("onDamage", parent.name, damageDataArray)
			isActive = false
	pass

func onStartHurtbox():
	isActive = true
	show()
	set_collision_layer_bit(5,true)
	set_collision_mask_bit(5,true)
	print("Start Kinematic Hurtbox")
	pass

func onEndHurtbox():
	isActive = false
	targetsAlreadyHit.clear()
	hide()
	set_collision_layer_bit(5,false)
	set_collision_mask_bit(5, false)
	print("End Kinematic Hurtbox")
	pass