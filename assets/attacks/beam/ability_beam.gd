extends Spatial

func _ready():
	pass

func onCharge():
	$ChargeUp.play()
	pass

func onHit():
	$AttackSound.play()
	pass