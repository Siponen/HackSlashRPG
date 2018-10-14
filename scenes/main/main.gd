extends Node

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var demoBoss = $World/DemoBoss
	demoBoss.threatSystem.currentTarget = $Player
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass