extends KinematicBody

var damageOnHit
var direction = Vector3()
var lifeTime = 5
var timer = 0
var speed = 10

func init(damage, dir, speed = 10):
	damageOnHit = damage
	direction = dir

func _physics_process(delta):
	var velocity = direction*speed*delta
	move_and_collide(velocity)
	
	timer += delta
	if timer > lifeTime: #Lifetime is over, reset or free (but reseting and reusing resources is better)
		queue_free()