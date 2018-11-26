# Auhtor: Conny 'Gentlemandapper' Siponen
# Based on Stefan Gustavsson's simplex implementation

const grad3 = [
	Vector3(1,1,0),Vector3(-1,1,0),Vector3(1,-1,0),Vector3(-1,-1,0),
	Vector3(1,0,1),Vector3(-1,0,1),Vector3(1,0,-1),Vector3(-1,0,-1),
	Vector3(0,1,1),Vector3(0,-1,1),Vector3(0,1,-1),Vector3(0,-1,-1)
	]

#Perlin's random integers
#var p = [151,160,137,91,90,15,
#  131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
#  190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
#  88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
#  77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
#  102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
#  135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
#  5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
#  223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
#  129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
#  251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
#  49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
#  138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180]

var p; var perm; var permMod12

const F2 = 0.36602540378
const G2 = 0.2113248654

func _init():
	p = []
	p.resize(256)
	perm = []
	perm.resize(512)
	permMod12 = []
	permMod12.resize(512)
	reseed()
	pass

func reseed():
	for i in range(256):
		p[i] = randi() % 255 + 1 # TODO better pseudo random distribution in the future.
		pass

	#Double the permutation table length for less wrapping overhead
	for i in range(512):
		perm[i]=p[i & 255]
		permMod12[i] = perm[i] % 12
		pass
	pass

func dot(g,x,y):
	return g.x*x + g.y*y
	pass

func fastfloor(x):
	var xi = int(x)
	var val
	if x<xi:
		val=xi-1
	else:
		val=xi
	return val

func octaveNoise2D(x, y, numOctaves, frequency, amplitude, lacunarity, persistance):
	var value = 0
	var denom = 0
	var freq = frequency
	var amp = amplitude
	
	for i in range(numOctaves):
		value += noise2D(x*freq, y*freq) * amp
		denom += amp
		freq *= lacunarity
		amp *= persistance
		
	return value / denom #Range [-1,1]

func noise2D(xin, yin):
	var n0; var n1; var n2
	#Skew the input space to determine the simplex cell
	var s = (xin+yin)*F2
	var i = fastfloor(xin+s)
	var j = fastfloor(yin+s)
	var t = (i+j)*G2
	var X0 = i-t
	var Y0 = j-t
	var x0 = xin-X0
	var y0 = yin-Y0
	
	#For the 2D case, the simplex is a triangle.
	#Determine which simplex we are in
	var i1; var j1
	if x0>y0: 
		i1=1; j1=0 #Lower triangle, the XY order is (0,0),(1,0),(1,1)
	else:
		i1=0; j1=1 #Upper triangle, the YX order is (0,0),(0,1),(1,1)
	
	var x1 = x0-i1+G2 #Offset for middle simplex corner in
	var y1 = y0-j1+G2
	var x2 = x0 - 1.0 + 2.0*G2 #Offset for last simplex corner
	var y2 = y0 - 1.0 + 2.0*G2
	
	#Work out the hashed gradient indices of the three simplex corners
	var ii = i & 255
	var jj = j & 255
	
	var gi0 = permMod12[ii+perm[jj]]
	var gi1 = permMod12[ii+i1+perm[jj+j1]]
	var gi2 = permMod12[ii+1+perm[jj+1]]
	
	#Calculate the contribution from the three simplex corners
	var t0 = 0.5-x0*x0-y0*y0
	if t0 < 0:
		n0 = 0.0
	else:
		t0 *= t0
		n0 = t0*t0*dot(grad3[gi0],x0,y0)
	
	var t1 = 0.5-x1*x1-y1*y1
	if t1 < 0:
		n1 = 0.0
	else:
		t1 *= t1
		n1 = t1*t1*dot(grad3[gi1], x1,y1)
	
	var t2 = 0.5-x2*x2-y2*y2
	if t2 < 0:
		n2 = 0.0
	else:
		t2 *= t2
		n2 = t2*t2*dot(grad3[gi2],x2,y2)
	#Add contributions from each corner to get the final noise value
	#The result is scaled to return values in the interval [-1,1]
	return 70.0*(n0+n1+n2)