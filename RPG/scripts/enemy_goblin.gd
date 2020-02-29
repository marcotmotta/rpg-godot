extends KinematicBody2D

enum {
	IDLE,
	CHANGE_DIRECTION,
	MOVE,
	ATTACK,
	HURT,
	DEAD
}

#var states = [IDLE, CHANGE_DIRECTION, MOVE, ATTACK, HURT, DEAD]

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
	randomize()
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
		CHANGE_DIRECTION:
			direction = choose([Vector2.RIGHT, Vector2.LEFT])
			state = MOVE
		MOVE:
			velocity.x = direction[0] * run_speed
			if(direction == Vector2.LEFT):
				$AnimatedSprite.set_flip_h(false)
				#$AttackArea/CollisionShape2D.position = Vector2(-abs($AttackArea/CollisionShape2D.position.x), $AttackArea/CollisionShape2D.position.y)
			else:
				$AnimatedSprite.set_flip_h(true)
				#$AttackArea/CollisionShape2D.position = Vector2(abs($AttackArea/CollisionShape2D.position.x), $AttackArea/CollisionShape2D.position.y)
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

func choose(array):
	array.shuffle()
	return array.front()

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'hurt':
		state = IDLE
		$AnimatedSprite.play("idle")
	elif $AnimatedSprite.animation == 'death':
		$HealthBar.visible = false
		state = DEAD

func take_damage(damage):
	health -= damage
	state = HURT
	if health > 0:
		$AnimatedSprite.play("hurt")
	else:
		$AnimatedSprite.play("death")

func is_ground_dead():
	if is_on_floor():
		ground_dead = true
		$CollisionShape2D.queue_free()
