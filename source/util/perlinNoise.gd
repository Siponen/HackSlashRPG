const perm = [ 151,160,137,91,90,15,
	131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
	190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
	88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
	77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
	102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
	135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
	5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
	223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
	129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
	251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
	49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
	138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
]

var p

func _init():
	p = [] #Double perm to avoid overflow
	#p array is used in a fash function that will determine what gradient vector to use.
	p.resize(512)
	for x in range(512):
		p[x] = perm[x%256]
	pass

func octavePerlin2D(x,y, octaves):
	var v = 0.0
	var scale = 1.0
	var amplitude = 1.0
	var amplitudeTotal = 0.0
	
	for i in range(octaves):
		v += perlin2D(x*scale, y*scale)*amplitude
		amplitudeTotal += amplitude
		scale *= 0.5
		amplitude *= 2
		pass
	return v / amplitudeTotal

func octavePerlin3D(x, y, z, numOctave):
	var total = 0
	var frequency = 1
	var amplitude = 1
	var maxValue = 0
	
	for i in range(numOctave):
		total += perlin3D(x*frequency, y*frequency, z*frequency)*amplitude
		maxValue += amplitude
		amplitude *= 0.5
		frequency *= 2
	
	return total/maxValue

func perlin2D(x,y):
	var xi = int(x) & 255
	var yi = int(y) & 255
	var xf = x-int(x)
	var yf = y-int(y)
	
	var u = fade(xf)
	var v = fade(yf)
	
	var a = p[p[xi]+yi]
	var b = p[p[xi+1]+yi]
	
	return keijiroLerp(v, keijiroLerp(u, grad2D(perm[a],x,y), grad2D(perm[b],x-1,y)),
		keijiroLerp(u, grad2D(perm[a+1], x, y-1), grad2D(perm[b+1], x-1, y-1)))

func perlin3D(x,y,z):
	var xi = int(x) & 255
	var yi = int(y) & 255
	var zi = int(z) & 255
	var xf = x-int(x)
	var yf = y-int(y)
	var zf = z-int(z)
	
	var u = fade(xf)
	var v = fade(yf)
	var w = fade(zf)
	
	#Perlin hash, hash all 8 unit cube coordinates surrounding input coordinate.
	var aaa = p[p[p[xi]+yi]+zi]
	var aba = p[p[p[xi]+yi+1]+zi]
	var aab = p[p[p[xi]+yi]+zi+1]
	var abb = p[p[p[xi]+yi+1]+zi+1]
	var baa = p[p[p[xi+1]+yi]+zi]
	var bba = p[p[p[xi+1]+yi+1]+zi]
	var bab = p[p[p[xi+1]+yi]+zi+1]
	var bbb = p[p[p[xi+1]+yi+1]+zi+1]
	
	#The gradient function calculates the dot product between
	#a pseudo random gradient vector and the vector from the input coordinate
	#to the 8 surrounding points in its unit cube
	var x1 = perlinLerp(grad3D(aaa,xf,yf,zf),grad3D(baa,xf-1,yf,zf),u)
	var x2 = perlinLerp(grad3D(aba,xf,yf-1,zf), grad3D(bba,xf-1,yf-1,zf),u)
	var y1 = perlinLerp(x1,x2,v)
	
	x1 = perlinLerp(grad3D(aab,xf,yf,zf-1),grad3D(bab,xf-1,yf,zf-1),u)
	x2 = perlinLerp(grad3D(abb,xf,yf-1,zf-1),grad3D(bbb,xf-1,yf-1,zf-1),u)
	var y2 = perlinLerp(x1,x2,v)
	return (perlinLerp(y1,y2,w)+1)*0.5

func fade(t):
	return t * t * t * (t *( t * 6 - 15) + 10) #6t^5 - 15t^4 + 10t^3 fade fall off function

func grad2D(theHash, x, y):
	var leftSide
	if theHash & 1 == 0: leftSide=x 
	else: leftSide=-x
	
	var rightSide
	if theHash & 2 == 0: rightSide = y 
	else: rightSide = -y
	return  leftSide + rightSide

func grad3D(theHash,x,y,z):
	match(theHash & 0xF):
		0x0: return  x + y
		0x1: return -x + y
		0x2: return  x - y
		0x3: return -x - y
		0x4: return  x + z
		0x5: return -x + z
		0x6: return  x - z
		0x7: return -x - z
		0x8: return  y + z
		0x9: return -y + z
		0xA: return  y - z
		0xB: return -y - z
		0xC: return  y + x
		0xD: return -y + z
		0xE: return  y - x
		0xF: return -y - z
		_: return 0
	pass

func perlinLerp(a,b,x):
	return a+x*(b-a)

func keijiroLerp(t,a,b):
	return a+t*(b-a)