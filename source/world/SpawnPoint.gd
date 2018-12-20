extends Area

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func spawn(player):
	player.global_transform.origin = global_transform.origin
	get_parent().add_child_below_node(player, "PlayersInMap")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass