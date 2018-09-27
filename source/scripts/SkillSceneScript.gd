extends Node

var animPlayer
var pausePoint
var damage

func _ready():
	animPlayer = get_node("AnimationPlayer")

func setDamage(_damage):
	damage = _damage
	pass

func start():
	animPlayer.play("attack")
	show()

func startFromPause():
	animPlayer.seek(pausePoint, true)
	animPlayer.play()
	show()
	pass

func pause():
	pausePoint = animPlayer.current_animation_position
	animPlayer.stop()
	pass

func stop():
	animPlayer.stop()
	animPlayer.seek(0,true) #Resets the animation player to position 0. stop(true) doesnt do this
	hide()
	pass