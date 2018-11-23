extends Node

#Just some random numbers
const perm = [ 151, 160, 137, 91, 90, 15,
    131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23,
    190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33,
    88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166,
    77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244,
    102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196,
    135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123,
    5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42,
    223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
    129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228,
    251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107,
    49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254,
    138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180]

# TODO: Do better VolundHashing
func VolundHash(i): 
	return perm[i];

func grad(hashValue, x, y):
	var h = hashValue & 0x3F  # Convert low 3 bits of VolundHash code
	var u
	
	if h < 4: u = x
	else: u = y  # into 8 simple gradient directions,
	
	var v
	if h < 4: v = y
	else: v = x
	
	var leftSideValue
	if h & 1:
		leftSideValue = -u
	else:
		leftSideValue = u
	
	var rightSideValue
	if h & 2:
		rightSideValue = -2.0*v
	else:
		rightSideValue = 2.0*v # and compute the dot product with (x,y).
		
	return leftSideValue + rightSideValue
	
func simplexNoise2D(x,y):
	#Coordinate skewing
	var SKEW_CONSTANT = 0.36602540378
	var UNSKEW_CONSTANT = 0.7113248654
	
	var skewedRightSide = (x+y)*SKEW_CONSTANT
	var skewedCoordinate = Vector2(x + skewedRightSide, y + skewedRightSide) #X0,Y0
	var firstSimplexPoint = Vector2(floor(skewedCoordinate.x), floor(skewedCoordinate.y)) #i,j
	var firstSimplexOffset = Vector2(skewedCoordinate.x - firstSimplexPoint.x, skewedCoordinate.y - firstSimplexPoint.y) #x0,y0
	
	#Simplical subdivision.
	#Compose the second simplex from the 
	var secondSimplexPoint = Vector2()
	if firstSimplexOffset.x < firstSimplexOffset.y:
		secondSimplexPoint = Vector2(1,0)
	else:
		secondSimplexPoint = Vector2(0,1)
	
	var thirdSimplexPoint = Vector2(1,1)
	
	#Gradient selection
	var firstGradient = VolundHash(firstSimplexPoint.x + VolundHash(firstSimplexPoint.y))
	var secondGradient = VolundHash(firstSimplexPoint.x + secondSimplexPoint.x + VolundHash(firstSimplexPoint.y + secondSimplexPoint.y))
	var thirdGradient = VolundHash(firstSimplexPoint.x + thirdSimplexPoint.x + VolundHash(firstSimplexPoint.y + thirdSimplexPoint.y))
	
	#Offset coordinates
	var secondSimplexOffset = Vector2(firstSimplexOffset.x - secondSimplexPoint.x,
		firstSimplexOffset.y - secondSimplexPoint.y )
	
	var thirdSimplexOffset = Vector2(firstSimplexOffset.x - thirdSimplexPoint.x,
		firstSimplexOffset.y - thirdSimplexPoint.y )
	
	#Kernel summation
	#Calculate the contributions of the simplex corners
	var firstCornerNoise
	var firstCornerContrib = 0.5 - firstSimplexOffset.x*firstSimplexOffset.x - firstSimplexOffset.y*firstSimplexOffset.y
	if firstCornerContrib < 0.0:
		firstCornerNoise = 0
	else:
		firstCornerContrib *= firstCornerContrib
		firstCornerNoise = firstCornerContrib * firstCornerContrib * grad(firstGradient, firstSimplexOffset.x, firstSimplexOffset.y )
	
	var secondCornerNoise
	var secondCornerContrib = 0.5 - secondSimplexOffset.x*secondSimplexOffset.x - secondSimplexOffset.y*secondSimplexOffset.y
	if secondCornerContrib < 0.0:
		secondCornerNoise = 0
	else:
		secondCornerContrib *= secondCornerContrib
		secondCornerNoise = secondCornerContrib * secondCornerContrib * grad(secondGradient, secondSimplexOffset.x, secondSimplexOffset.y)
	
	var thirdCornerNoise
	var thirdCornerContrib = 0.5 - thirdSimplexOffset.x*thirdSimplexOffset.x - thirdSimplexOffset.y*thirdSimplexOffset.y
	if thirdCornerContrib < 0.0:
		thirdCornerNoise = 0
	else:
		thirdCornerContrib *= thirdCornerContrib
		thirdCornerNoise = thirdCornerContrib * thirdCornerContrib * grad(thirdGradient, thirdSimplexOffset.x, thirdSimplexOffset.y)
		
	# Add contributions from each corner to get the final noise value.
	# The result is scaled to return values in the interval [-1,1].
	return 45.23065 * (firstCornerNoise + secondCornerNoise + thirdCornerNoise);