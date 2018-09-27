extends Camera

var player
var upDirection = Vector3(0,1,0)
var offset = Vector3(0,7,5)

func _ready():
	set_as_toplevel(true)
	player = get_parent()
	pass

func _process(delta):
	var playerPosition = player.global_transform.origin
	var position = playerPosition + offset
	global_transform.origin = position
	self.look_at( playerPosition, upDirection )
	pass