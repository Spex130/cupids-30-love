class_name GameManager extends Node3D

@export var GameArena : Arena
@export var BrickBlocks : Array[BasicBlock] #Blocks that must be defeated to win
@export var SpecialBrickBlocks : Array[BasicBlock] #Blocks that don't need to be defeated to win.
@onready var brickPrefab = preload("res://Prefabs/StandardBlock.tscn")

@export var level : int = 0
@export var LevelComplete : bool = false


var LowerPlayfieldBound = -12
var UpperPlayfieldBound = -48

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CreateBlockRowAtRowIndex(10, 1.125, 13)
	CreateBlockRowAtRowIndex(26, 1.125, 13)
	CreateBlockRowAtRowIndex(48, 1.125, 13)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass

func CreateBlockRowAtRowIndex(row:int, horizontalMargin:float, count:int) ->void:
	var leftEnd = GameArena.Width/2 * -1
	var startPoint = Vector3(leftEnd + 3, 0, GetRowZValue(row))
	CreateBlockRow(startPoint, horizontalMargin, count)
		
	pass

func CreateBlockRow(startPoint:Vector3, horizontalMargin:float, count:int) -> void:
	for n in count:
		CreateSingleBlock(startPoint + Vector3(4 * n * horizontalMargin, 0, 0))
	pass

func CreateSingleBlock(targetPosition:Vector3) -> void:
	var brick = brickPrefab.instantiate() as BasicBlock
	brick.position = targetPosition
	BrickBlocks.append(brick)
	add_child(brick)
	pass
	
func GetRowZValue(row:int) -> float:
	return LowerPlayfieldBound - .5 * row
	pass
	
	
