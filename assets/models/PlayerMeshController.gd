extends Spatial

func _ready():
	$AnimationPlayer.get_animation("Walk").loop = true
	pass

func startAnimation(animName):
	$AnimationPlayer.play(animName)
	pass

func stopAnimation():
	$AnimationPlayer.stop()
	pass