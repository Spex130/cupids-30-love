class_name BasicBlock extends Node3D

@export var health : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func GetHit(damage:int):
	health-=damage
	if(health <= 0):
		queue_free()
	pass
