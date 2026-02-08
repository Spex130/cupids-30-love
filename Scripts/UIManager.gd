extends Node

@export var gameManager : GameManager
@export var player : PlayerChar
@export var ChargeDisplay : ProgressBar
@export var lifelabel:RichTextLabel
@export var levellabel:RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	ChargeDisplay.max_value = player.shotPowerMax
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifelabel.text = str(gameManager.lives)
	levellabel.text = str(gameManager.level)
	ChargeDisplay.value = lerp(ChargeDisplay.value, player.shotPower as float, .1)
	pass


func _on_texture_button_3_pressed() -> void:
	pass # Replace with function body.
