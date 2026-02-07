extends Node

@export var pausecontainer : NinePatchRect
@export var targetButton : TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("pause"):
		if get_tree().paused:
			resumeGame()
		else:
			pausecontainer.visible = true
			targetButton.grab_focus()
		get_tree().paused = !get_tree().paused
	pass

func resumeGame():
	pausecontainer.visible = false
	targetButton.grab_focus()
	targetButton.grab_focus(true)
	pass


func _on_texture_button_pressed():
	resumeGame()
	get_tree().paused = !get_tree().paused
		
	pass # Replace with function body.
