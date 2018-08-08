extends Area

func _ready():
	connect("body_entered",self,"threatBodyEntered")
	pass
	
func bodyEntered(body):
	print("")
	pass