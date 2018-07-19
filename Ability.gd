var attackNode = null
var attackName
var damage = 0
var cooldown = 0
var timer = 0
var onCooldown = false

func _init(_attackName, _damage, _cooldownTime):
	attackName = _attackName
	damage = _damage
	cooldown = _cooldownTime

func update(delta):
	if onCooldown:
		timer += delta
		if timer > cooldown:
			onCooldown = false

func setOnCooldown():
	timer = 0
	onCooldown = true