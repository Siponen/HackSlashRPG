extends StaticBody

var itemId
var itemName
var itemTypeName
var itemRarity #Normal, Magic, Rare, Legendary

func init(_position,_itemId, _itemTypeName):
	global_transform.origin = _position
	itemId = _itemId
	$RichTextLabel.text = _itemTypeName
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass