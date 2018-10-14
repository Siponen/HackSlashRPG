extends Area

var boss
var bodiesInArea = {}

func _ready():
	boss = get_parent()
	connect("body_entered",self,"onBodyEnter")
	connect("body_exited",self,"onBodyExit")
	set_collision_mask_bit(PhysicsLayers.PLAYER_BODY_BIT,true)
	pass
	
func onBodyEnter(body):
	bodiesInArea[body.name] = body
	boss.onTrigger(body)
	print("Boss ", boss.bossName," is triggered by ", body.name)
	pass
	
func onBodyExit(body):
	bodiesInArea[body.name] = null
	print(get_parent().bossName, " stops caring for", body.name)
	pass