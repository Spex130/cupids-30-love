class_name Heartbreaker extends CharacterBody3D

# Drag References
@export var gameManager : GameManager
@export var arena : Arena
@export var player: PlayerChar
@export var animator : AnimationPlayer
@export var moveTimer:Timer

#spawn-in
var hasSpawned:bool = false

# Stats
@export var health : int = 1
@export var movespeed : float = .1
var isDead = false

#Logic Setters
enum EnemyType {Wait, Patrol, HorizontalBounce, ColumnTrack}
@export var enemyType: EnemyType = EnemyType.Wait

#Patrol Logic
@export var PatrolSpot1 : Vector3 = position
@export var PatrolSpot2 : Vector3 = position
var TowardsPoint1:bool = false
var PatrolThreshold = .1

#Horizontal Bounce Logic
var IsMovingLeft = false

enum EnemyShootType {TimedShooter, ColumnShooter}
@export var shootType : EnemyShootType = EnemyShootType.TimedShooter
@export var CanShoot : bool = false
var MaxTimer : float = 0
@export var ShootTimer : float = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	MaxTimer = ShootTimer
	animator.play("Heartbreaker_Spawn")
	if enemyType == EnemyType.Patrol:
		position = PatrolSpot1
		moveTimer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !isDead:
		EnemyLogic()
	pass

func EnemyLogic() -> void:
	match(enemyType):
		EnemyType.Wait:
			position = position
		EnemyType.Patrol:
			PatrolLogic()	
		EnemyType.HorizontalBounce:
			if IsMovingLeft:
				move_and_collide(Vector3.LEFT * movespeed)
			else:
				move_and_collide(Vector3.RIGHT * movespeed)
				
			if global_position.x <= arena.position.x - arena.Width/2:
				global_position.x = arena.position.x - arena.Width/2+.1
				IsMovingLeft = !IsMovingLeft
			if global_position.x >= arena.position.x + arena.Width/2:
				global_position.x = arena.position.x + arena.Width/2-.1
				IsMovingLeft = !IsMovingLeft
	pass

func PatrolLogic():
	if(TowardsPoint1):
		global_position = lerp(PatrolSpot2, PatrolSpot1, moveTimer.time_left/moveTimer.wait_time)

	else:
		global_position = lerp(PatrolSpot1, PatrolSpot2, moveTimer.time_left/moveTimer.wait_time)
	pass

func GetHit(damage:int):
	health -=damage
	if(health <= 0):
		isDead = true
		gameManager.RemoveEnemy(self)
		animator.play("Heartbreaker_Death")
	else:
		animator.play("Heartbreaker_Hit")
		
	pass

func _on_timer_timeout():
	TowardsPoint1 = !TowardsPoint1
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	match(anim_name):
		"Heartbreaker_Spawn":
			animator.play("Heartbreaker_Idle")
		"Heartbreaker_Hit":
			animator.play("Heartbreaker_Idle")
		"Heartbreaker_Shot":
			animator.play("Heartbreaker_Idle")
		"Heartbreaker_Death":
			queue_free()
		
	pass # Replace with function body.
