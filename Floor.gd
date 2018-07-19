extends StaticBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var value = 0
	for i in range(20):
		if get_collision_mask_bit(i):
			value += pow(2,i)
			print('Layer ',i, ' Value ', pow(2,i))
		pass
	print('Mask value: ', value)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
