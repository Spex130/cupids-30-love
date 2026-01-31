class_name Ball extends RigidBody3D

@export var BallMesh : MeshInstance3D
@export var BallCollider : CollisionShape3D
@export var Direction : Vector3 = Vector3(1, 0, -1)
@export var Speed : float = 1
@export var Size : float = 1
@export var ParentArena : Arena

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta):
	var collision_info = move_and_collide(Direction * Speed * delta)
	if(collision_info != null):
		var normal = collision_info.get_normal()
		if(Vector3.BACK.dot(normal) > 0.1 || Vector3.FORWARD.dot(normal) > 0.1):
			FlipDirectionZ()

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#position += Direction * Speed
	BallMesh.scale = Vector3(Size, Size, Size)
	#BallCollider.scale = Vector3(Size, Size, Size)
	WallCheck()
	pass
	
func FlipDirectionX() -> void:
	Direction.x *= -1
	pass
func FlipDirectionZ() -> void:
	Direction.z *= -1
	pass
func WallCheck() -> void:
	var CalcSize = Size/2
	if position.x + CalcSize > ParentArena.RightWall:
		FlipDirectionX()
		position.x = ParentArena.RightWall - CalcSize
	if position.x - CalcSize < ParentArena.LeftWall:
		FlipDirectionX()
		position.x = ParentArena.LeftWall + CalcSize
	if position.z - CalcSize < ParentArena.TopWall:
		FlipDirectionZ()
		position.z = ParentArena.TopWall + CalcSize
	if position.z + CalcSize > ParentArena.BottomWall:
		FlipDirectionZ()
		position.z = ParentArena.BottomWall - CalcSize
	pass
