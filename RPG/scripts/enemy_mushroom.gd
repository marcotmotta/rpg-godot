extends KinematicBody2D

enum {
	IDLE,
	MOVE,
	ATTACK,
	HURT,
	DEAD
}

export (int) var run_speed = 100
export (int) var max_health = 100
export (int) var damage = 10

onready var global = get_node("/root/global")
onready var health = max_health

var velocity = Vector2()
var state = IDLE
var direction = Vector2.LEFT
var attacking = false
var ground_dead = false

func _ready():
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	$AnimatedSprite.play("idle")

func _physics_process(delta):
	$HealthBar.value = health
	velocity.x = 0
	velocity.y += global.gravity * delta

	match state:
		IDLE:
			pass
		MOVE:
			for character in $VisionRange.get_overlapping_bodies():
				if character.is_in_group('Player'):
					if self.position.x > character.position.x:
						direction = Vector2.LEFT
					else:
						direction = Vector2.RIGHT
					break

			velocity.x = direction[0] * run_speed
			$AnimatedSprite.set_flip_h(direction[0] < 1)
			var range_position_x = direction[0] \
				* abs($AttackRange/CollisionShape2D.position.x)
			$AttackRange/CollisionShape2D.position.x = range_position_x
			$AttackDamage/CollisionShape2D.position.x = range_position_x
			$AnimatedSprite.play("run")
		ATTACK:
			pass
		HURT:
			pass
		DEAD:
			if ground_dead:
				velocity.y = 0
			else:
				is_ground_dead()

	velocity = move_and_slide(velocity, global.floor_normal)

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'hurt':
		state = IDLE
		$AnimatedSprite.play("idle")
		$VisionRange/CollisionShape2D.set_deferred('disabled', false)
		$AttackRange/CollisionShape2D.set_deferred('disabled', false)
	elif $AnimatedSprite.animation == 'death':
		$HealthBar.visible = false
		state = DEAD
	elif $AnimatedSprite.animation == 'attack_step_01':
		$AnimatedSprite.play("attack_step_02")
		$AttackDamage/CollisionShape2D.disabled = false
	elif $AnimatedSprite.animation == 'attack_step_02':
		$AttackDamage/CollisionShape2D.disabled = true
		state = IDLE
		$AnimatedSprite.play("idle")
		if $AttackRange.get_overlapping_bodies():
			$AttackRange/CollisionShape2D.disabled = true
			$AttackRange/CollisionShape2D.disabled = false
		elif len($VisionRange.get_overlapping_bodies()) > 2:
			$VisionRange/CollisionShape2D.disabled = true
			$VisionRange/CollisionShape2D.disabled = false

func take_damage(dmg):
	health -= dmg
	state = HURT
	$VisionRange/CollisionShape2D.set_deferred('disabled', true)
	$AttackRange/CollisionShape2D.set_deferred('disabled', true)
	$AttackDamage/CollisionShape2D.set_deferred('disabled', true)
	if health > 0:
		$AnimatedSprite.play("hurt")
	else:
		$AnimatedSprite.play("death")

func is_ground_dead():
	if is_on_floor():
		ground_dead = true
		$CollisionShape2D.queue_free()
		$VisionRange.queue_free()
		$AttackRange.queue_free()
		$AttackDamage.queue_free()

func _on_VisionRange_body_entered(body):
	if body.is_in_group('Player') and state != ATTACK:
		state = MOVE

func _on_VisionRange_body_exited(body):
	if state != DEAD and state != HURT:
		state = IDLE
		$AnimatedSprite.play("idle")

func _on_AttackRange_body_entered(body):
	if body.is_in_group("Player"):
		state = ATTACK
		print('aa')
		$AnimatedSprite.play("attack_step_01")

func _on_AttackDamage_body_entered(body):
	if body.is_in_group('Player'):
		body.take_damage(damage, $AnimatedSprite.flip_h)
