extends Area

func _ready():
	connect("body_entered",self,"threatBodyEntered")
	pass
	
func bodyEntered(body):
	print("Boss ", get_parent().bossName," is triggered by ", body.name)
	pass