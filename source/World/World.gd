extends Node

var itemsNode
var lootScene = preload("res://source/looting/Loot.tscn")
var lootTables = {}

signal drop_loot

func _ready():
	itemsNode = $Items
	#addLoot(Vector3(10,0,10),{"itemId": "tomahawk", "itemTypeName": "Two-handed Axe"})
	pass

func _process(delta):
	pass

func addLoot(_position, _lootData):
	var loot = lootScene.instance()
	loot.init(_position,_lootData.itemId, _lootData.itemTypeName)
	itemsNode.add_child(loot)
	pass
	
func addLootTable(_enemyId, _lootTable):
	lootTables[_enemyId] = _lootTable
	pass