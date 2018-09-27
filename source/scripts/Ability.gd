extends Spatial

var parent
var animPlayer

#Ability data
var attackName
var abilityType # Evasion, Counter, Normal
var inputType #Point, Direction, None
var playerAnimationName

#Attack timer
var atkTimer = 0
var currentAttackTime = 0 #Until you can input another attack, unless it's a dodge
var normalAttackTime
var isAttacking = false

#Cooldown
var cdTimer = 0
var currentCooldownTime = 0
var normalCooldownTime
var onCooldown = false

func _ready():
	parent = get_parent()
	animPlayer = get_node("AnimationPlayer")

func _init(_attackName, _attackTime, _cooldownTime):
	attackName = _attackName
	normalAttackTime = _attackTime
	normalCooldownTime = _cooldownTime

func _process(delta):
	if onCooldown:
		cdTimer += delta
		if cdTimer >= currentCooldownTime:
			cooldownFinished()

	if isAttacking:
		atkTimer += delta
		if atkTimer >= currentAttackTime:
			attackFinished()

func attack():
	if onCooldown == false:
		startAttack(normalAttackTime)
		startCooldown(normalCooldownTime)
		animPlayer.play("attack")
		show()
		parent.emit_signal("attack_started", self)

func cancel():
	stopAttack()
	stopCooldown()
	stopAnimation()
	hide()
	parent.emit_signal("attack_cancelled", self)
	pass

func disrupt(cooldownValue):
	stopAttack()
	startCooldown(cooldownValue)
	parent.emit_signal("attack_disrupted", self)
	pass

func startAttack(attackTime):
	atkTimer = 0
	currentAttackTime = attackTime
	isAttacking = true

func stopAttack():
	atkTimer = 0
	currentAttackTime = normalAttackTime
	isAttacking = false

func attackFinished():
	isAttacking = false
	atkTimer = 0
	parent.emit_signal("attack_finished", self)
	pass

func startCooldown(cooldownTime):
	cdTimer = 0
	currentCooldownTime = cooldownTime
	onCooldown = true
	pass

func stopCooldown():
	cdTimer = 0
	currentCooldownTime = normalCooldownTime
	onCooldown = false

func cooldownFinished():
	onCooldown = false
	cdTimer = 0

func stopAnimation():
	animPlayer.stop()
	animPlayer.seek(0,true) #Resets the animation player to position 0. stop(true) doesnt do this
	pass