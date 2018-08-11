extends Area

var damageOnHit
var direction = Vector3()
var lifeTime = 5
var timer = 0
var speed = 10

func init(damage, dir, speed = 10):
	damageOnHit = damage
	direction = dir

func _ready():
	connect("body_entered",self,"onHit")

func _physics_process(delta):
		global_transform.origin += direction*speed*delta
		timer += delta
		if timer > lifeTime: #Lifetime is over, reset or free (but reseting and reusing resources is better)
			queue_free()

func onHit(body):
	if body.has_node("Health"):
		queue_free()
		print("Bullet hit ", body.name, " for ", damageOnHit, " damage.")