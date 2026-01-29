class_name Arena extends Node3D

@export var CollisionShape : CollisionShape3D
@export var MeshInstance : MeshInstance3D
@export var Width = 60
@export var Length = 60
@export var FrontMargin = -20

@export var LeftWall : float
@export var RightWall : float
@export var TopWall : float
@export var BottomWall : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InitArena()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SetArena(WidthIn:float, LengthIn:float, Margin:float) -> void:
	Width = WidthIn
	Length = LengthIn
	FrontMargin = Margin
	CollisionShape.scale.x = Width
	MeshInstance.scale.x = Width
	CollisionShape.scale.z = Length
	MeshInstance.scale.z = Length
	CalculateWalls()
	pass
	
func InitArena() -> void:
	CollisionShape.scale.x = Width
	MeshInstance.scale.x = Width
	CollisionShape.scale.z = Length
	MeshInstance.scale.z = Length
	position.x = 0
	position.z = FrontMargin
	CalculateWalls()
	pass
	
func CalculateWalls() -> void:
	LeftWall = position.x - Width/2
	RightWall = position.x + Width/2
	TopWall = position.y - Length/2 + FrontMargin
	BottomWall = position.y + Length/2 + FrontMargin
	pass
