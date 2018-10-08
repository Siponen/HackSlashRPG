var parent
var targetPosition

var moveSpeed

func _init(_parent):
	parent = _parent
	pass

func onEnter():
	pass

func onExit():
	pass

func update(delta):
	if targetPosition == null:
		parent.emit_signal("set_state","idle")
	pass

func physics(delta):
	var direction = targetPosition - parent.global_transform.origin
	direction = direction.normalize()
	parent.move_and_collide(direction*moveSpeed*delta)
	pass