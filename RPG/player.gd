extends KinematicBody2D

export (int) var run_speed = 300
export (int) var jump_speed = -500
export (int) var gravity = 1500

var velocity = Vector2()
var floor_normal = Vector2.UP
var jumping = false
var attacking = false

func _ready():
	$AnimationPlayer.play("idle")

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('right')
	var left = Input.is_action_pressed('left')
	var jump = Input.is_action_just_pressed('up')
	var attack = Input.is_action_just_pressed('attack')

	if !attacking:
		if attack:
			pass
		else:
			if jump and is_on_floor():
				jumping = true
				velocity.y = jump_speed
			if right:
				velocity.x += run_speed
				$AnimatedSprite.set_flip_h(false)
				$SwordHit.scale = Vector2(abs($SwordHit.scale.x), $SwordHit.scale.y)
			if left:
				velocity.x -= run_speed
				$AnimatedSprite.set_flip_h(true)
				$SwordHit.scale = Vector2(-abs($SwordHit.scale.x), $SwordHit.scale.y)

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity, floor_normal)
