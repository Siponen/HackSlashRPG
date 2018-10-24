extends Spatial

var animPlayer
var pausePoint
var damageArray = []

var index = 0
var numStates = 0

func _ready():
	animPlayer = get_node("AnimationPlayer")

func addDamage(_damageInstance):
	damageArray.append(_damageInstance)
	pass

func setDamage(_index, _damageInstance):
	if _index < 0 and _index < damageArray.size():
		damageArray[_index] = _damageInstance
	pass

func start(animName):
	animPlayer.play(animName)
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