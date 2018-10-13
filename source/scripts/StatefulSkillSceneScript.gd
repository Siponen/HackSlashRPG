#This is a skill scene script cycle through animations by step.
#Normally used in repeatable attacks like, basic attacks.

extends Spatial

var animPlayer
var pausePoint

var damageArray = []
var numSteps

func _ready():
	animPlayer = get_node("AnimationPlayer")

func setSteps(_numSteps):
	numSteps = _numSteps

func addDamage(_damageInstance):
	damageArray.append(_damageInstance)

func setDamage(_index, _damageInstance):
	if _index > 0 and _index <= numSteps:
		damageArray[_index] = _damageInstance
	pass

func start(animName):
	animPlayer.play(animName)
	show()
	pass

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