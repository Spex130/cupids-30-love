class_name GameManager extends Node3D

@export var player : PlayerChar
@export var GameArena : Arena
@export var GameOverZone : Area3D
@export var BrickBlocks : Dictionary = {} #Blocks that must be defeated to win
@export var SpecialBrickBlocks : Array[BasicBlock] #Blocks that don't need to be defeated to win.
@export var Enemies : Dictionary = {}
@onready var brickPrefab = preload("res://Prefabs/StandardBlock.tscn")
@onready var enemyPrefab = preload("res://Prefabs/Heartbreaker.tscn")

var tween: Tween

@export var level : int = 0
@export var lives : int = 3
@export var TrackLevelCompletion: bool = false
@export var LevelComplete : bool = false


var LowerPlayfieldBound = -12
var UpperPlayfieldBound = -48

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	#Zero everything out.
	GameArena.MeshInstance.scale = Vector3.ZERO
	tween.tween_property(GameArena.MeshInstance, "scale", Vector3(0, 0, 0), 0)
	GameOverZone.scale = Vector3.ZERO
	tween.tween_property(GameOverZone, "scale", Vector3.ZERO, 0)
	
	#Game Arena Spawn-in
	tween.tween_property(GameArena.MeshInstance, "scale", Vector3(60, .1, 1), .5)
	tween.tween_property(GameArena.MeshInstance, "scale", Vector3(60, .1, 60), .5)
	tween.tween_property(GameArena.MeshInstance, "scale", Vector3(60, .5, 60), .5)
	
	#Game Over Zone Spawn-in
	tween.tween_property(GameOverZone, "scale", Vector3(.1, .1, 1), .5)
	tween.tween_property(GameOverZone, "scale", Vector3(1, 1, 1), .5)
	
	SpawnLevel(0)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(TrackLevelCompletion):
		if(BrickBlocks.is_empty() && Enemies.is_empty()):
			SpawnLevel(1)
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
	brick.gameManager = self
	var origScale = brick.scale
	brick.position = targetPosition + Vector3.UP * 5
	brick.scale = Vector3.ZERO
	BrickBlocks[brick] = brick
	add_child(brick)
	tween.tween_property(brick, "position", targetPosition, .05)
	tween.parallel().tween_property(brick, "scale", origScale, .05)
	pass
	
func RemoveBrick(brick:BasicBlock):
	BrickBlocks.erase(brick)
	pass
	
func CreateWaitEnemy(targetPosition:Vector3, health:int, scale:float):
	var heartbreaker = enemyPrefab.instantiate() as Heartbreaker
	heartbreaker.gameManager = self
	heartbreaker.arena = GameArena
	heartbreaker.player = player
	Enemies[heartbreaker] = heartbreaker
	heartbreaker.position = targetPosition
	heartbreaker.health = health
	heartbreaker.scale *= scale
	add_child(heartbreaker)
	pass
	
func RemoveEnemy(enemy:Heartbreaker):
	Enemies.erase(enemy)
	pass
	
func GetRowZValue(row:int) -> float:
	return LowerPlayfieldBound - .5 * row
	pass
	
func SpawnLevel(level:int):
	#We use this to make a version of the Spawn method that can get called in the Tween order
	tween = create_tween()
	var CallableEnemySpawn = Callable(self, "CreateWaitEnemy")
	match(level):
		0:
			CreateSingleBlock(Vector3(0, 0, -30))
		1:
			CreateBlockRowAtRowIndex(10, 1.125, 13)
			CreateBlockRowAtRowIndex(26, 1.125, 13)
			CreateBlockRowAtRowIndex(48, 1.125, 13)
			tween.tween_callback(CreateWaitEnemy.bind(Vector3(0, 0, -30), 2, 2))
			
	TrackLevelCompletion = true
	pass
	
