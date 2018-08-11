extends "res://assets/scripts/Ability.gd"

var Emitter = preload("res://assets/prefabs/bullets/BarrageBulletEmitter.tscn")

func _init().("Doom Barrage", 2, 60):
	pass

func attack(targetPosition):
	if self.onCooldown == false:
		var emitterInst = Emitter.instance()
		emitterInst.init(targetPosition)
		add_child(emitterInst)