extends Spatial

var player

var skills
var currentSkill

var isCondition
var isGivingInput

signal change_state

func _ready():
	player = get_parent()

	connect("change_state", self, "onChangeState")

func onUpdate(delta):
	currentState
	pass
	
func onPhysics(delta):
	pass
	
func onChangeState(nextState):
	currentState = nextState
	pass