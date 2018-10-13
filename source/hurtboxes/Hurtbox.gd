extends Area

var isDamagingPlayers
var isDamagingWorld

var isShowingCollisionBox
var collisionBoxType #Box, Circle, Cone, Projectile

func _init(_isDamagingPlayers, _isDamagingWorld, _collisionBoxType):
	pass

func _ready():
	match(collisionBoxType):
		"Cone":
			var collisionShape = CollisionShape.new()
			collisionShape.shape = makeConeShape()
			add_child(collisionShape)
			
			if isShowingCollisionBox:
				var meshInstance = MeshInstance.new()
				add_child(meshInstance)
				pass
	pass

func makeBoxShape(width,height):
	var shape = BoxShape.new()

func makeConeShape(width, height): #A good ratio is twice the width of height
	var shape = ConvexPolygonShape.new()
	#/| left polygon
	shape.points.append(Vector3(0,0,0))
	shape.points.append(Vector3(-width,0,height))
	shape.points.append(Vector3(0,0,height))
	#|\ right polygon
	shape.points.append(Vector3(0,0,0))
	shape.points.append(Vector3(width,0,height))
	shape.points.append(Vector3(0,0,height))
	return shape

func startHurtBox():
	startHurtBoxCollision()
	if showCollisionBox:
		pass
	
	pass

func endHurtBox():
	endHurtBoxCollision()
	pass

func startHurtBoxCollision():
	if isDamagingPlayers:
		set_collision_layer_bit(PhysicsLayers.PLAYER_DAMAGE_BIT, true)
		set_collision_mask_bit(PhysicsLayers.PLAYER_DAMAGE_BIT, true)
	if isDamagingWorld:
		set_collision_layer_bit(PhysicsLayers.ENEMY_DAMAGE_BIT, true)
		set_collision_mask_bit(PhysicsLayers.ENEMY_DAMAGE_BIT, true)

func endHurtBoxCollision():
	if isDamagingPlayers:
		set_collision_layer_bit(PhysicsLayers.PLAYER_DAMAGE_BIT, false)
		set_collision_mask_bit(PhysicsLayers.PLAYER_DAMAGE_BIT, false)
	if isDamagingWorld:
		set_collision_layer_bit(PhysicsLayers.ENEMY_DAMAGE_BIT, false)
		set_collision_mask_bit(PhysicsLayers.ENEMY_DAMAGE_BIT, false)
	pass
	