class_name PauseManager extends Node

@export var pausecontainer : NinePatchRect
@export var gameovercontainer : NinePatchRect
@export var wincontainer : NinePatchRect
@export var targetButton : TextureButton
@export var pausable: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("pause") && pausable:
		if get_tree().paused:
			resumeGame()
		else:
			pauseGame()
	pass

func resumeGame():
	pausecontainer.visible = false
	targetButton.grab_focus()
	targetButton.grab_focus(true)
	get_tree().paused = !get_tree().paused
	pass

func pauseGame():
	pausecontainer.visible = true
	targetButton.grab_focus()
	get_tree().paused = !get_tree().paused
	
	pass

func gameOver():
	pausable = false
	get_tree().paused = !get_tree().paused
	gameovercontainer.visible = true
	pass
	
func win():
	pausable = false
	get_tree().paused = !get_tree().paused
	wincontainer.visible = true
	pass

func restartGame():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/GameScenes.tscn")
	pass

func quitGame():
	get_tree().quit() 
	pass

func _on_texture_button_pressed():#reusme
	resumeGame()
		
	pass # Replace with function body.


func _on_texture_button_2_pressed() -> void:#retry
	restartGame()
	pass # Replace with function body.


func _on_texture_button_3_pressed() -> void:#quit
	quitGame()
	pass # Replace with function body.
