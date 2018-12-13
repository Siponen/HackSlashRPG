extends Spatial

var Simplex = preload("res://source/util/simplexNoise.gd")
var simplex = Simplex.new()

var Perlin = preload("res://source/util/perlinNoise.gd")
var perlin = Perlin.new()

var sprite

const worldCellsOnWidth = 3
const worldCellsOnHeight = 3

const cellWidth = 64
const cellLength = 64

var terrainBatch
var imageTexture
var image

var meshBatches = []

func _ready():
	#Heightmap texture
	$WorldEditorGUI/MapCorner/HeightMap.rect_min_size = Vector2(cellWidth,cellLength)
	$WorldEditorGUI/MapCorner/HeightMap.rect_size = Vector2(cellWidth,cellLength)
	$WorldEditorGUI/MapCorner/HeightMap/Viewport/Sprite.scale = Vector2(256 / cellWidth, 256 / cellLength)
	terrainBatch = $TerrainBatch.new(cellWidth,cellLength,2)
	sprite = $WorldEditorGUI.get_node("MapCorner/HeightMap/Viewport/Sprite")
	
	imageTexture = ImageTexture.new()
	image = Image.new()
	image.create(cellWidth,cellLength, false, Image.FORMAT_RGBA8)
	
	makeSimplexHeightMap()
	pass

func simplexToNormalRange(value):
	#Jump from range -1,1 to 0,255.
	value += 1 #Add 1 to make it to range 0,2
	value *= 0.5 #Then divide it to get range 0,1.
	return value

func buildSimplexMapArray(xStart, yStart):
	var heightMap = []
	for y in range(cellLength):
		heightMap.append([])
		heightMap[y].resize(cellWidth)
		for x in range(cellWidth):
			heightMap[y][x] = simplex.octaveNoise2D(xStart+x,yStart+y,16,1,100,0.7,100) #x, y, numOctaves, frequency, amplitude, lacunarity, persistance
	return heightMap

func buildRandomNoiseMapArray():
	randomize()
	var heightMap = []
	for y in range(cellLength):
		heightMap.append([])
		heightMap[y].resize(cellWidth)
		for x in range(cellWidth):
			var n = randf()
			var firstPass = n*0.1 
			heightMap[y][x] = randf()
	return heightMap

func buildPerlinMapArray():
	randomize()
	var heightMap = []
	for y in range(cellLength):
		heightMap.append([])
		heightMap[y].resize(cellWidth)
		for x in range(cellWidth):
			heightMap[y][x] = perlin.octavePerlin3D(randf(),randf(),randf(),4)
	return heightMap
	pass

func updateHeightMapTexture(noiseArray):
	image.lock()
	for y in range(cellLength):
		for x in range(cellWidth):
			#var color
			var value = noiseArray[y][x]
			image.set_pixel(x,y,Color(value,value,value))
			#if value >= 0.7: color = Color(value,value,value,1.0) #Grey / White
			#elif value <= 0.4: color = Color(0,0,255,1.0) #Water
			#elif value <= 0.45: color = Color(255,255,0, 1.0) #Sand
			#else: color = Color(0,value,0) #Grass
			#image.set_pixel(x,y,color)
			pass
		pass
	image.unlock()
	imageTexture.create_from_image(image)
	sprite.texture = imageTexture
	pass

func updateSimplexHeightMapTexture(noiseArray):
	image.lock()
	for y in range(cellLength):
		for x in range(cellWidth):
			#var color
			var value = (noiseArray[y][x]+1)*0.5 #Normalize to range [0,1]
			#if value >= 0.7: color = Color(value,value,value,1.0) #Grey / White
			#elif value <= 0.4: color = Color(0,0,255,1.0) #Water
			#elif value <= 0.45: color = Color(255,255,0, 1.0) #Sand
			#else: color = Color(0,value,0) #Grass
			#image.set_pixel(x,y,color)
			image.set_pixel(x,y,Color(value,value,value))
			pass
		pass
	image.unlock()
	imageTexture.create_from_image(image)
	sprite.texture = imageTexture
	pass

func makeSimplexHeightMap():
	var simplexArray = buildSimplexMapArray(0,0)
	updateSimplexHeightMapTexture(simplexArray)
	terrainBatch.buildMesh(simplexArray)
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		simplex.reseed()
		makeSimplexHeightMap()
