class_name PlayerChar extends Node3D

@export var ParentArena : Arena 
@export var Velocity : float = 0
@export var WalkSpeed : float = .085
@export var StopSpeed = .2
@export var MaxWalkSpeed : float = 1
@export var IsMovingLeft : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		Velocity = min(MakePositive(Velocity) + WalkSpeed, MaxWalkSpeed)
	elif Input.is_action_pressed("move_left"):
		Velocity = max(MakeNegative(Velocity) -WalkSpeed, MakeNegative(MaxWalkSpeed))
	else:
		Velocity = Lerp(Velocity, 0, StopSpeed)
	position.x += Velocity
	WallCheck()
	pass

func WallCheck() -> void:
	var CalcSize = 1
	if position.x + CalcSize > ParentArena.RightWall:
		Velocity = 0
		position.x = ParentArena.RightWall - CalcSize
	if position.x - CalcSize < ParentArena.LeftWall:
		Velocity = 0
		position.x = ParentArena.LeftWall + CalcSize
	if position.z - CalcSize < ParentArena.TopWall:
		Velocity = 0
		position.z = ParentArena.TopWall + CalcSize
	if position.z + CalcSize > ParentArena.BottomWall:
		Velocity = 0
		position.z = ParentArena.BottomWall - CalcSize
	pass

func MakePositive(number: float) -> float:
	return abs(number)
	pass
	
func MakeNegative(number: float) -> float:
	return abs(number) * -1
	pass	

func Lerp (A: float, B: float, t: float) -> float:
	return A + (B - A) * t
	pass
