var parent

func _init(_parent):
	parent = _parent
	connect("start_skill", self, "startSkill")
	pass