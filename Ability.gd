extends Spatial

var attackName
var animPlayer
var cooldown = 0
var timer = 0
var onCooldown = false

func _init(_attackName, _cooldownTime):
	attackName = _attackName
	cooldown = _cooldownTime

func _process(delta):
	if onCooldown:
		timer += delta
		if timer >= cooldown:
			onCooldown = false
			timer = 0

func setOnCooldown():
	timer = 0
	onCooldown = true
	pass