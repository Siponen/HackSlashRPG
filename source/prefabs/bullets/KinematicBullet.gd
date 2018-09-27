extends KinematicBody

var damage
var direction
var moveSpeed

var onHitData = {}

func init(_damage,_direction,_moveSpeed):
	damage = _damage
	direction = _direction
	moveSpeed = _moveSpeed
	
	onHitData = {"damage": _damage}
	pass

func _physics_process(delta):
	var velocity = direction * moveSpeed * delta
	var collision = move_and_collide(velocity)
	if collision != null:
		var collider = collision.collider
		collider.emit("on_hit", onHitData)
	pass