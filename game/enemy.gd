extends KinematicBody2D

export (int) var gravity = 1500

var velocity = Vector2()
var floor_normal = Vector2(0, -1)

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, floor_normal)
