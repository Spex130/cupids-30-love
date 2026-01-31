class_name PlayerChar extends Node3D

@export var ParentArena : Arena 
@export var Velocity : float = 0
@export var WalkSpeed : float = .085
@export var StopSpeed = .4
@export var SlowSpeed = .1
@export var MaxWalkSpeed : float = 1
@export var IsMovingLeft : bool = false
@export var PlayerAnimator : AnimationPlayer 
var ExpectedRotation = 0
enum PlayerState {Entry, Idle, Run, ChargeL, ChargeR, SwingL, SwingR}
@export var CharacterState : PlayerState = PlayerState.Idle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerAnimator.play("CupidIdle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	StateMachineCheck()
	WallCheck()
	pass

func ChangeState(state: PlayerState) -> void:
	CharacterState = state
	match(CharacterState):
		PlayerState.Idle:
			SetExpectedRotation(0)
			PlayerAnimator.play("CupidIdle")
		PlayerState.Run:
			if(IsMovingLeft):
				SetExpectedRotation(90)
			else:
				SetExpectedRotation(-90)
			PlayerAnimator.play("CupidRun")
		PlayerState.ChargeL:
			SetExpectedRotation(0)
			PlayerAnimator.play("CupidChargeL")
		PlayerState.ChargeR:
			SetExpectedRotation(0)

			PlayerAnimator.play("CupidChargeR")
		PlayerState.SwingL:
			SetExpectedRotation(0)

			PlayerAnimator.play("SwingL")
		PlayerState.SwingR:
			SetExpectedRotation(0)

			PlayerAnimator.play("SwingR")
	pass

func StateMachineCheck() -> void:
	rotation.y = ThresholdLerp(rotation.y, ExpectedRotation, .5, .1)
	match(CharacterState):
	
		PlayerState.Idle:
			Velocity = Lerp(Velocity, 0, StopSpeed)
			
			if Input.is_action_pressed("move_right"):
				IsMovingLeft = false
				ChangeState(PlayerState.Run)
			elif Input.is_action_pressed("move_left"):
				IsMovingLeft = true
				ChangeState(PlayerState.Run)
			elif Input.is_action_pressed("accept"):
				if(IsMovingLeft):
					ChangeState(PlayerState.ChargeL)
				else:
					ChangeState(PlayerState.ChargeR)
				
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
			
			if Input.is_action_just_released("move_right") || Input.is_action_just_released("move_left"):
				ChangeState(PlayerState.Idle)

		PlayerState.ChargeL:
			Velocity = Lerp(Velocity, 0, SlowSpeed)
			if Input.is_action_just_released("accept"):
				ChangeState(PlayerState.SwingL)
		PlayerState.ChargeR:
			Velocity = Lerp(Velocity, 0, SlowSpeed)
			if Input.is_action_just_released("accept"):
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

func SetExpectedRotation(degrees: float) -> void:
	ExpectedRotation = degrees * 0.01745329 #Convert to Radians
	pass

func Lerp (A: float, B: float, t: float) -> float:
	return A + (B - A) * t
	pass
	
func ThresholdLerp (A: float, B: float, t: float, threshold:float) -> float:
	if(abs(A-B) <= threshold):
		return B
	return A + (B - A) * t
	pass


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"SwingL":
			ChangeState(PlayerState.Idle)
		"SwingR":
			ChangeState(PlayerState.Idle)
	pass
