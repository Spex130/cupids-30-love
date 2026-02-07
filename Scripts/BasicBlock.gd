class_name BasicBlock extends Node3D

@export var gameManager: GameManager
@export var collider : CollisionShape3D
@export var health : int = 1
@export var length = 4
@export var width = 16


# Called when the node enters the scene tree for the first time.
func _ready():
	#tween.set_trans(Tween.TRANS_SPRING)
	#tween.set_ease(Tween.EASE_IN)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func GetHit(damage:int):
	health-=damage
	if(health <= 0):
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SPRING)
		tween.set_ease(Tween.EASE_IN)
		gameManager.RemoveBrick(self)
		#collider.disabled = true
		tween.parallel().tween_property(self, "scale", Vector3.ZERO, .2)
		tween.tween_callback(queue_free)
	pass
