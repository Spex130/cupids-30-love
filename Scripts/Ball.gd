class_name Ball extends RigidBody3D

@export var BallMesh : MeshInstance3D
@export var BallCollider : CollisionShape3D
@export var Direction : Vector3 = Vector3(1, 0, -1)
@export var Speed : float = 1
@export var Size : float = 1
@export var ParentArena : Arena
var normal

# Launch mode is where the ball follows a target until it is hit.
@export var LaunchMode:bool = false
@export var FollowTarget:PlayerChar
@export var FollowClosenessMargin = 4
enum FollowSpot {Front, Left, Right}
@export var LaunchPoint:FollowSpot = FollowSpot.Front

@export var UseBounceCount = false
@export var BounceCount = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OnSpawn()
	pass # Replace with function body.

func OnSpawn():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3.ZERO, 0)
	tween.tween_property(self, "scale", Vector3.ONE, .25)
	pass

func Despawn():
	var tween = create_tween()
	BallCollider.disabled = true
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3.ZERO, .25)
	FollowTarget.TempBallList.erase(self)
	tween.tween_callback(queue_free)
	pass

func _physics_process(delta):
	
	if LaunchMode:
		match(LaunchPoint):
			FollowSpot.Front:
				position = lerp(position, FollowTarget.position+Vector3.FORWARD * FollowClosenessMargin, .1)
			FollowSpot.Left:
				position = lerp(position, FollowTarget.position+Vector3.LEFT * FollowClosenessMargin, .1)
			FollowSpot.Right:
				position = lerp(position, FollowTarget.position+Vector3.RIGHT * FollowClosenessMargin, .1)
				
	else:
		var collision_info = move_and_collide(Direction * Speed * delta)
		var TypeIsFound = false
		if(collision_info != null):
			normal = collision_info.get_normal()
			
			#Check if Block
			#print(collision_info.get_collider())
			var block = GetTopLevelParent(collision_info.get_collider()) as BasicBlock
			if(block != null):
				TypeIsFound = true
				block.GetHit(1)
				
			#Check if Heartbreaker
			if(!TypeIsFound):
				var heartBreaker = GetTopLevelParent(collision_info.get_collider()) as Heartbreaker
				if(heartBreaker != null):
					TypeIsFound = true
					heartBreaker.GetHit(1)
					
			#Ball Bounce logic
			var bounced = false
			if(Vector3.BACK.dot(normal) > 0.1 || Vector3.FORWARD.dot(normal) > 0.1):
				FlipDirectionZ()
				bounced = true
				
			if(Vector3.RIGHT.dot(normal) > 0.1 || Vector3.LEFT.dot(normal) > 0.1):
				FlipDirectionX()
				bounced = true
				
			if UseBounceCount && bounced:
				BounceCount-=1
				if BounceCount == 0:
					Despawn()
	pass

#Recursive Function to find Parent. top_level
func GetTopLevelParent(node:Node3D) -> Node3D:
	if(node.top_level):
		return node
	elif(node.get_parent_node_3d() != null):
		return GetTopLevelParent(node.get_parent_node_3d())
	else:
		return null
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#position += Direction * Speed
	BallMesh.scale = Vector3(Size, Size, Size)
	BallCollider.scale = Vector3(Size, Size, Size)
	WallCheck()
	pass

func LaunchBall(direction:Vector3):
	LaunchMode = false
	Direction = direction
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
