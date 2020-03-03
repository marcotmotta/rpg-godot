extends KinematicBody2D

# Camera signal.
signal grounded_updated(is_grounded)

export (int) var run_speed = 200
export (int) var jump_speed = -550
export (int) var max_health = 100
export (int) var damage = 40

onready var global = get_node("/root/global")
onready var health = max_health

var jumping = false
var blocking = false
var attacking = false
var taking_damage = false
var velocity = Vector2()

# Camera variables.
var is_grounded
var facing = 0

func _ready():
	$AnimatedSprite.play("idle")

func _input_process():
	var left = Input.is_action_pressed('left')
	var right = Input.is_action_pressed('right')
	var block = Input.is_action_pressed("down")
	var jump = Input.is_action_just_pressed('up')
	var attack = Input.is_action_just_pressed('attack')
	
	if health > 0 and !attacking and !taking_damage:
		facing = 1 if right else -1 if left else 0

		if attack:
			attacking = true
			blocking = false
			$AnimatedSprite.play("attack_step_01")

		else:
			blocking = block
			
			if blocking:
				$AnimatedSprite.play("block")

			else:
				if jump and is_on_floor():
					velocity.y = jump_speed
					jumping = true

				if right or left:
					velocity.x += facing * run_speed
					$AnimatedSprite.set_flip_h(facing < 0)
					$AttackRange/CollisionShape2D.position.x = facing * abs($AttackRange/CollisionShape2D.position.x)
					$AnimatedSprite.play("run")

				else:
					$AnimatedSprite.play("idle")

func _physics_process(delta):
	# Camera configs.
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	
	velocity.x = 0
	velocity.y += global.gravity * delta
	
	_input_process()
	
	velocity = move_and_slide(velocity, global.floor_normal)
	
	if jumping and is_on_floor():
		jumping = false
	
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_updated", is_grounded)

func take_damage(dmg, enemy_direction):
	if !blocking or $AnimatedSprite.flip_h == enemy_direction:
		health -= dmg

		if health > 0:
			$AnimatedSprite.play("hurt")
			taking_damage = true
			attacking = false
			blocking = false

		else:
			$AnimatedSprite.play("death")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'attack_step_01':
		$AttackRange/CollisionShape2D.disabled = false
		$AnimatedSprite.play("attack_step_02")
		$AttackSound.play()

	elif $AnimatedSprite.animation == 'attack_step_02':
		$AttackRange/CollisionShape2D.disabled = true
		$AnimatedSprite.play("idle")
		attacking = false

	elif $AnimatedSprite.animation == 'hurt':
		$AnimatedSprite.play("idle")
		taking_damage = false

func _on_AttackRange_body_entered(body):
	if body.is_in_group('Enemies'):
		body.take_damage(damage)
