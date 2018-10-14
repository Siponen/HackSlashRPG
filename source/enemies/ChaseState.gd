var parent
var targetPosition
var moveSpeed = 2

var isActive = false

func _init(_parent):
	parent = _parent
	pass

func onEnter():
	isActive = true
	targetPosition = parent.currentTarget
	pass

func onExit():
	isActive = false
	pass

func update(delta):
	if isActive:
		if targetPosition == null:
			parent.emit_signal("set_state","idle")
			onExit()
	pass

func physics(delta):
	if isActive:
		var direction = (targetPosition.global_transform.origin - parent.global_transform.origin).normalized()
		direction.y = 0
		parent.move_and_collide(direction*moveSpeed*delta)
	pass