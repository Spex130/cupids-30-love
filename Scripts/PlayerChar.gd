class_name PlayerChar extends Node3D

@export var ParentArena : Arena 
@export var PointerCircle : MeshInstance3D
@export var PlayerModel : Node3D
@export var Velocity : float = 0
@export var WalkSpeed : float = .085
@export var StopSpeed = .4
@export var SlowSpeed = .1
@export var MaxWalkSpeed : float = 0.5
@export var IsMovingLeft : bool = false
@export var PlayerAnimator : AnimationPlayer 
@export var TempBallList : Dictionary = {}

#Power Shot vars
@export var shotAngle : float = 0
var shotAngleMax = 75
var shotAngleSpeed = 1
var shotPowerMin = 1.5
@export var shotPower = shotPowerMin
var shotPowerMax = 3
var shotPowerGrowth = .01
@export var vectorDirection : Vector3 = Vector3.FORWARD


# Prefab PackedScenes

@onready var hitboxPrefab = preload("res://Prefabs/RacketHitbox.tscn")
@onready var singleshotPrefab = preload("res://Prefabs/SingleShotBall.tscn")

var ExpectedRotation = 0
enum PlayerState {Entry, Idle, Run, ChargeL, ChargeR, SwingL, SwingR}
@export var CharacterState : PlayerState = PlayerState.Idle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SetExpectedRotation(360)
	PlayerAnimator.play("CupidIdle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	StateMachineCheck()
	WallCheck()
	PointerCheck()
	pass

func ChangeState(state: PlayerState) -> void:
	CharacterState = state
	SetPointerVisibility(false)
	ResetPowerShotParams()
	match(CharacterState):
		PlayerState.Idle:
			SetExpectedRotation(360)
			PlayerAnimator.play("CupidIdle")
		PlayerState.Run:
			if(IsMovingLeft):
				SetExpectedRotation(-200)
			else:
				SetExpectedRotation(200)
			PlayerAnimator.play("CupidRun")
		PlayerState.ChargeL:
			SetExpectedRotation(360)
			SetPointerVisibility(true)
			PlayerAnimator.play("CupidChargeL")
		PlayerState.ChargeR:
			SetExpectedRotation(360)
			SetPointerVisibility(true)
			PlayerAnimator.play("CupidChargeR")
		PlayerState.SwingL:
			SetExpectedRotation(360)
			PlayerAnimator.play("SwingL")
		PlayerState.SwingR:
			SetExpectedRotation(360)
			PlayerAnimator.play("SwingR")
	pass

func StateMachineCheck() -> void:
	PlayerModel.global_rotation.y = ThresholdLerp(rotation.y, ExpectedRotation, .5, .1)
	match(CharacterState):
	
		PlayerState.Idle:
			Velocity = Lerp(Velocity, 0, StopSpeed)
			
			if Input.is_action_pressed("move_right"):
				IsMovingLeft = false
				ChangeState(PlayerState.Run)
			elif Input.is_action_pressed("move_left"):
				IsMovingLeft = true
				ChangeState(PlayerState.Run)
			if Input.is_action_pressed("accept"):
				if(IsMovingLeft):
					ChangeState(PlayerState.ChargeL)
				else:
					ChangeState(PlayerState.ChargeR)
					
			if Input.is_action_just_released("decline"):
				CreateOneshotBall()
				
		PlayerState.Run:
			if IsMovingLeft == false:
				Velocity = min(MakePositive(Velocity) + WalkSpeed, MaxWalkSpeed)
			elif IsMovingLeft == true:
				Velocity = max(MakeNegative(Velocity) -WalkSpeed, MakeNegative(MaxWalkSpeed))
			
			if Input.is_action_pressed("accept"):
				if(IsMovingLeft):
					ChangeState(PlayerState.ChargeL)
				else:
					ChangeState(PlayerState.ChargeR)
					
			if Input.is_action_just_released("decline"):
				CreateOneshotBall()
					
			if Input.is_action_just_released("move_right") || Input.is_action_just_released("move_left"):
				ChangeState(PlayerState.Idle)

		PlayerState.ChargeL:
			Velocity = Lerp(Velocity, 0, SlowSpeed)
			ShotHoldBehavior()
			
			if Input.is_action_just_released("accept"):
				CreateHitbox()
				ChangeState(PlayerState.SwingL)

		PlayerState.ChargeR:
			Velocity = Lerp(Velocity, 0, SlowSpeed)
			ShotHoldBehavior()
			
			if Input.is_action_just_released("accept"):
				CreateHitbox()
				ChangeState(PlayerState.SwingR)
				
		PlayerState.SwingL:
			Velocity = Lerp(Velocity, 0, StopSpeed)
			if Input.is_action_pressed("accept") && PlayerAnimator.current_animation_position > .2:
				if(IsMovingLeft):
					ChangeState(PlayerState.ChargeL)
				else:
					ChangeState(PlayerState.ChargeR)
			SwingIASA()
		PlayerState.SwingR:
			Velocity = Lerp(Velocity, 0, StopSpeed)
			if Input.is_action_pressed("accept") && PlayerAnimator.current_animation_position > .2:
				if(IsMovingLeft):
					ChangeState(PlayerState.ChargeL)
				else:
					ChangeState(PlayerState.ChargeR)
			SwingIASA()
	
	position.x += Velocity
	pass

func CreateHitbox() -> void:
	var hitbox = hitboxPrefab.instantiate() as RacketHitbox
	hitbox.HitDirection = vectorDirection
	hitbox.Power = shotPower
	add_child(hitbox)
	pass

func SwingIASA() -> void:
	if PlayerAnimator.current_animation_position > .5:
		if Input.is_action_pressed("move_right"):
			IsMovingLeft = false
			ChangeState(PlayerState.Run)
		elif Input.is_action_pressed("move_left"):
			IsMovingLeft = true
			ChangeState(PlayerState.Run)

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

func ShotHoldBehavior() -> void:
	if(Input.is_action_pressed("move_right")):
		shotAngle = max(shotAngle - shotAngleSpeed, -shotAngleMax)
	elif(Input.is_action_pressed("move_left")):
		shotAngle = min(shotAngle + shotAngleSpeed, shotAngleMax)
	shotPower = min(shotPower+shotPowerGrowth, shotPowerMax)
	pass

func SetExpectedRotation(degrees: float) -> void:
	ExpectedRotation = DegreesToRadians(degrees)#Convert to Radians
	pass

func DegreesToRadians(degrees: float) -> float:
	return degrees * 0.01745329 #Convert to Radians
	pass

func PointerCheck() -> void:
	PointerCircle.rotation.y = DegreesToRadians(shotAngle)
	var vectorDirectionVec2 : Vector2 = Vector2(cos(DegreesToRadians(shotAngle)), sin(DegreesToRadians(shotAngle)))
	vectorDirection = Vector3(-vectorDirectionVec2.y, 0, -vectorDirectionVec2.x)
	pass

func SetPointerVisibility(vis:bool) -> void:
	PointerCircle.visible = vis
	pass
func ResetPowerShotParams() -> void: 
	shotAngle = 0
	shotPower = shotPowerMin
	PointerCircle.rotation.y = 0
pass
func Lerp (A: float, B: float, t: float) -> float:
	return A + (B - A) * t
	pass
	
func ThresholdLerp (A: float, B: float, t: float, threshold:float) -> float:
	if(abs(A-B) <= threshold):
		return B
	return A + (B - A) * t
	pass

func CreateOneshotBall():
	var count = TempBallList.size()
	if count < 2:
		var ball = singleshotPrefab.instantiate() as Ball
		ball.position = position + Vector3.UP * ball.FollowClosenessMargin * 5
		ball.FollowTarget = self
		ball.LaunchMode = true
		ball.ParentArena = ParentArena
		if count == 0:
			ball.LaunchPoint = ball.FollowSpot.Left
		else:
			ball.LaunchPoint = ball.FollowSpot.Right
		get_parent().add_child(ball)
		TempBallList[ball] = ball
	pass

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"SwingL":
			ChangeState(PlayerState.Idle)
		"SwingR":
			ChangeState(PlayerState.Idle)
	pass
