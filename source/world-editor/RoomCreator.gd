extends Spatial

# Randomize exits, but always keep a higher level Map creator determine the one guaranteed exit, and randomize the rest.
# Use depth as a stopping condition to avoid infinite spreading levels.

var tiles
var sizeType = {"small": Vector2(9,9), "medium": Vector2(20,20), "large": Vector2(40,40)  }
var width = 10
var height = 10

var textureRect
var textRect

func _ready():
	tiles = []
	textRect = $Control/VBoxContainer/HBoxContainer/TextEdit
	textureRect = $Control/VBoxContainer/HBoxContainer2/TextureRect
	textureRect.rect_size = Vector2(width,height)
	randomize()
	var numEntries = randi() % 4
	for y in range(height):
		tiles.append([])
		var line = ""
		for x in range(width):
			var val = randi() % 4
			tiles[y].append(val)
			line += (str(val) + " ")
			pass
		textRect.text += (line + "\n")
	
	var roomImage = Image.new()
	roomImage.create(width,height, false, Image.FORMAT_RGBA8)
	roomImage.lock()
	for y in range(width):
		for x in range(height):
			var tileId = tiles[y][x]
			match tileId:
				0: roomImage.set_pixel(x,y, Color(0,0,0,255)) #Nothing
				1: roomImage.set_pixel(x,y, Color(255,255,255,255)) #Walls
				2: roomImage.set_pixel(x,y, Color(255,0,0,255)) #Doors
				3: roomImage.set_pixel(x,y, Color(0,255,0,255)) #Floor
	roomImage.unlock()
	initTextureRect(roomImage)
	pass

func initTextureRect(theImage):
	var roomTexture = ImageTexture.new()
	roomTexture.create_from_image(theImage)
	textureRect.texture = roomTexture
	pass

func _process(delta):
	
	pass