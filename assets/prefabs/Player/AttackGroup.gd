extends Spatial

var isAttacking = false
var currentAttack = null

var attackSet = {}

signal attack_started
signal attack_finished
signal attack_cancelled
signal attack_disrupted

func _ready():
	connect("attack_started",self, "attackStarted")
	connect("attack_cancelled",self,"attackCancelled")
	connect("attack_finished", self, "attackFinished")
	pass

func attackStarted(node):
	isAttacking = true
	currentAttack = node
	print("Player starts ", node.attackName)
	pass

func attackFinished(node):
	isAttacking = false
	currentAttack = null
	print("Player attack ", node.attackName ," has finished")

func attackCancelled(node):
	isAttacking = false
	currentAttack = null
	print("Player cancelled ", node.attackName)
	pass