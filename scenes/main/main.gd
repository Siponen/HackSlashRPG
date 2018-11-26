extends Node

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var demoBoss = $World/DemoBoss
	demoBoss.threatSystem.currentTarget = $Player
	
	for y in range(8):
		var line = ""
		for x in range(8):
			var val = Noise.simplexNoise2D(x,y)
			line += String(val)
			line += " "
		print(line)
	pass

func _process(delta):
	pass