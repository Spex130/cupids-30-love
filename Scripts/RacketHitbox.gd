class_name RacketHitbox extends Node3D

@export var BallDetector : Area3D
@export var Power : float = 1
@export var HitDirection : Vector3 = Vector3.FORWARD
@export var Lifetime : float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Lifetime -= delta
	if Lifetime <= 0:
		queue_free()
	pass


func _on_area_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var ball:Ball = body as Ball
	if(ball != null):
		var ballCollider = ball.get_child(0) as CollisionShape3D
		if(ballCollider!= null):
			print("Pongball Detected!")
			ball.Direction = HitDirection * Power
			queue_free()
	pass 
