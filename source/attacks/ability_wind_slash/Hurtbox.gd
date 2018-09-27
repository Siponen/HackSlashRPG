extends Area
#Hurtbox.gd

signal damage_body

func _ready():
	connect("body_entered",self,"on_body_enter")
	pass

func on_body_enter(body):
	if body.has_node("Health"): #This body has a Health Component extended on Node
		var healthNode = body.get_node("Health")
		print(body.name," has health component")
		healthNode.onDamage(50)
	else:
		print(body.name," has no health component")
	pass