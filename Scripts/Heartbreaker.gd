class_name Heartbreaker extends Node3D

# Drag References
@export var arena : Arena
@export var player: PlayerChar
@export var animator : AnimationPlayer
@export var moveTimer:Timer

#tween setup
var tween = create_tween()

# Stats
@export var health : int = 1
@export var movespeed : float = 1

#Logic Setters
enum EnemyType {Wait, Patrol, HorizontalBounce, ColumnTrack}
@export var enemyType: EnemyType = EnemyType.Wait

#Patrol Logic
@export var PatrolSpot1 : Vector3 = position
@export var PatrolSpot2 : Vector3 = position
var TowardsPoint1:bool = false
var PatrolThreshold = .1


enum EnemyShootType {TimedShooter, ColumnShooter}
@export var shootType : EnemyShootType = EnemyShootType.TimedShooter
@export var CanShoot : bool = false
var MaxTimer : float = 0
@export var ShootTimer : float = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	MaxTimer = ShootTimer
	if enemyType == EnemyType.Patrol:
		position = PatrolSpot1
		moveTimer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	PatrolLogic()
	pass

func EnemyLogic() -> void:
	match(enemyType):
		EnemyType.Wait:
			position = position
			
	pass

func PatrolLogic():
	if(TowardsPoint1):
		global_position = lerp(PatrolSpot2, PatrolSpot1, moveTimer.time_left/moveTimer.wait_time)

	else:
		global_position = lerp(PatrolSpot1, PatrolSpot2, moveTimer.time_left/moveTimer.wait_time)
	pass

func _on_timer_timeout():
	TowardsPoint1 = !TowardsPoint1
	pass # Replace with function body.
