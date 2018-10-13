var parent

var moveTimer = 0
var moveCooldown = 0.5

#var startPosition
#var endPosition

func _init(_parent):
	parent = _parent
	randomize()

func update(delta):
	pass
	
func physics(delta):
	moveTimer += delta
	if moveTimer > moveCooldown:
		var velX = rand_range(-1,1)
		var velY = rand_range(-1,1)
		parent.move_and_collide(Vector3(velX * parent.walkSpeed, -0.5, velY * parent.walkSpeed))
		moveTimer = 0
	pass