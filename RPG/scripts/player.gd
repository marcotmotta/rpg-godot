extends KinematicBody2D

export (int) var run_speed = 100
export (int) var jump_speed = -500

onready var global = get_node("/root/global")

var velocity = Vector2()
var jumping = false
var attacking = false

func _ready():
	$AnimatedSprite.play("idle")

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('right')
	var left = Input.is_action_pressed('left')
	var jump = Input.is_action_just_pressed('up')
	var attack = Input.is_action_just_pressed('attack')

	if !attacking:
		if attack:
			attack_start()
		else:
			if jump and is_on_floor():
				jumping = true
				velocity.y = jump_speed
			if right:
				velocity.x += run_speed
				$AnimatedSprite.set_flip_h(false)
			if left:
				velocity.x -= run_speed
				$AnimatedSprite.set_flip_h(true)
	
			if velocity.x != 0:
				$AnimatedSprite.play("run")
			else:
				$AnimatedSprite.play("idle")

func _physics_process(delta):
	get_input()
	velocity.y += global.gravity * delta
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity, global.floor_normal)

func attack_start():
	attacking = true
	$AnimatedSprite.play("attack")
	#$SwordHit/CollisionShape2D.disabled = false

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'attack':
		attacking = false
		$AnimatedSprite.play("idle")
