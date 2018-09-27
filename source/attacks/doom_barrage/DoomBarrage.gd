extends "res://source/scripts/Ability.gd"

var Emitter = preload("res://source/prefabs/bullets/BarrageBulletEmitter.tscn")

func _init().("Doom Barrage", 2, 3):
	pass

func attack(targetPosition):
	if not self.onCooldown:
		.attack()
		var emitterInst = Emitter.instance()
		emitterInst.init(targetPosition)
		add_child(emitterInst)