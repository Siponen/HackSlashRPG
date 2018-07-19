extends KinematicBody

signal on_hit
signal on_stun
signal on_death

var health = 100

func _ready():
	connect("on_hit", self, "onHit")
	connect("on_stun", self, "onStun")
	connect("on_death", self, "onDeath")
	pass
	
func randomMoveAround(delta):
	pass

func onHit():
	#Do whatever
	pass

func onStun():
	#Do whatever
	pass

func onDeath():
	$DeathSound.play()
	pass