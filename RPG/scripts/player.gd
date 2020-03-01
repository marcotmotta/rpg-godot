extends KinematicBody2D

# camera signal
signal grounded_updated(is_grounded)

enum {
	IDLE,
	MOVE,
	ATTACK,
	HURT,
	DEAD
}

export (int) var run_speed = 200
export (int) var jump_speed = -550
export (int) var damage = 40

onready var global = get_node("/root/global")

var velocity = Vector2()
var jumping = false
var attacking = false

# camera variables
var is_grounded
var facing = 0

func _ready():
	$AnimatedSprite.play("idle")

func get_input():
	velocity.x = 0
	facing = 0
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
				facing += 1
				velocity.x += run_speed
				$AnimatedSprite.set_flip_h(false)
				$AttackRange/CollisionShape2D.position.x = abs($AttackRange/CollisionShape2D.position.x)
			if left:
				facing -= 1
				velocity.x -= run_speed
				$AnimatedSprite.set_flip_h(true)
				$AttackRange/CollisionShape2D.position.x = -abs($AttackRange/CollisionShape2D.position.x)

			if velocity.x != 0:
				$AnimatedSprite.play("run")
			else:
				$AnimatedSprite.play("idle")

func _physics_process(delta):
	get_input()
	velocity.y += global.gravity * delta
	
	velocity = move_and_slide(velocity, global.floor_normal)

	if jumping and is_on_floor():
		jumping = false

	# Camera configs
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_updated", is_grounded)

func attack_start():
	attacking = true
	$AnimatedSprite.play("attack1")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'attack1':
		$AnimatedSprite.play("attack2")
		$Attack.play()
		$AttackRange/CollisionShape2D.disabled = false
	elif $AnimatedSprite.animation == 'attack2':
		attacking = false
		$AttackRange/CollisionShape2D.disabled = true
		$AnimatedSprite.play("idle")

func _on_AttackRange_body_entered(body):
	if(body.is_in_group('Enemies')):
		body.take_damage(damage)
