tool
extends MeshInstance

var width
var length
var widthCells
var lengthCells
var offsetX
var offsetZ
var scaling

var st

func _ready():
	st = SurfaceTool.new()
	pass
	
func new(_width, _height, _scaling):
	width = _width
	length = _height
	widthCells = width - 1
	lengthCells = length - 1
	offsetX = width*0.5
	offsetZ = length*0.5
	scaling = _scaling
	return self

func buildMesh(noiseArray):
	var mesh = Mesh.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	#Material ground = Material.new()
	#Create the vertices
	for z in range(length):
		for x in range(width):
			st.add_vertex(Vector3(x, noiseArray[z][x]*scaling, z))
			
	#Create the indices for each quad in the grid
	for row in range(0,lengthCells):
		for column in range(0,widthCells):
			var lowerLeftCorner = column + (row*length)
			var lowerRightCorner = lowerLeftCorner + 1
			var upperLeftCorner = lowerLeftCorner + length
			var upperRightCorner = upperLeftCorner + 1

			#|/
			st.add_index(lowerLeftCorner)
			st.add_index(upperLeftCorner)
			st.add_index(upperRightCorner)
			#/|
			st.add_index(lowerLeftCorner)
			st.add_index(upperRightCorner)
			st.add_index(lowerRightCorner)
	
	st.generate_normals()
	st.commit(mesh)
	self.set_mesh(mesh)
	pass