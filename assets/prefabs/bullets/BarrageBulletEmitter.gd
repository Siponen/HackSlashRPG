extends Spatial

var Bullet = preload("res://assets/prefabs/bullets/Bullet.tscn")
var upDirection = Vector3(0,1,0)

var numProjectiles = 5
var rotationPerStep = 2*PI / numProjectiles

var numShots = 10
var shootTime = 0.5
var timer = 0
var countShots = 0

func _ready():
	pass

func init(targetPosition):
	global_transform.origin = targetPosition
	pass

func _process(delta):
	timer += delta
	if timer > shootTime:
		shoot()
		timer -= shootTime
		countShots += 1
		if countShots >= numShots:
			queue_free()
	pass
	
func shoot():
	var direction = Vector3(1,0,0)
	for i in range(numProjectiles):
		var aBullet = Bullet.instance()
		aBullet.init(10,direction,30)
		$MeshInstance.add_child(aBullet)
		direction = direction.rotated(upDirection,rotationPerStep)