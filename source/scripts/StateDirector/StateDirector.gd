var parent

var activeState
var loadedStates = {}

var stateSequence
var nextState
var nextStateData

signal next_state

func _init(_parent):
	parent = _parent
	connect("next_state", self, "nextState")
	pass

func setActive(stateKey):
	activeState = loadedStates[stateKey]
	activeState.onEnter()
	pass

func addState(stateKey, state):
	state.parent = parent
	state.director = self
	loadedStates[stateKey] = state
	pass

func update(delta):
	activeState.update(delta)
	pass

func physics(delta):
	activeState.physics(delta)
	pass

func nextState(_nextStateKey, onEnterData):
	activeState.onExit()
	if _nextStateKey != null:
		print("Director: Next state! ", _nextStateKey)
		activeState = loadedStates[_nextStateKey]
		activeState.onEnter(onEnterData)
	else:
		activeState = loadedStates["default"]
		activeState.onEnter()
	pass