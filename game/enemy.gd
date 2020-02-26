extends KinematicBody2D

enum {
	CHANGE_DIRECTION,
	MOVE,
	ATTACK,
	THROW
}

var states = [CHANGE_DIRECTION, MOVE, ATTACK, THROW]

var throw_scene = preload("res://ThrowAttack.tscn")

export (int) var run_speed = 100
export (int) var gravity = 1500
export (int) var max_health = 100
export (int) var damage = 20

onready var health = max_health

var velocity = Vector2()
var floor_normal = Vector2.UP
var state = MOVE
var direction = Vector2.LEFT
var attacking = false

func _ready():
	randomize()
	$AnimatedSprite.set_flip_h(false)
	$EnemyLifeBar.max_value = max_health
	$EnemyLifeBar.value = health

func _physics_process(delta):
	velocity.x = 0
	$EnemyLifeBar.value = health
	velocity.y += gravity * delta

	if !attacking:
		match state:
			CHANGE_DIRECTION:
				direction = choose([Vector2.RIGHT, Vector2.LEFT])
				state = MOVE
			MOVE:
				velocity.x = direction[0] * run_speed
				if(direction == Vector2.LEFT):
					$AnimatedSprite.set_flip_h(false)
					$AttackArea/CollisionShape2D.position = Vector2(-abs($AttackArea/CollisionShape2D.position.x), $AttackArea/CollisionShape2D.position.y)
					$ThrowPosition.position = Vector2(-abs($ThrowPosition.position.x), $ThrowPosition.position.y)
				else:
					$AnimatedSprite.set_flip_h(true)
					$AttackArea/CollisionShape2D.position = Vector2(abs($AttackArea/CollisionShape2D.position.x), $AttackArea/CollisionShape2D.position.y)
					$ThrowPosition.position = Vector2(abs($ThrowPosition.position.x), $ThrowPosition.position.y)
				$AnimatedSprite.play("run")
			ATTACK:
				attack_start()
			THROW:
				throw_attack_start()

	velocity = move_and_slide(velocity, floor_normal)

func choose(array):
	array.shuffle()
	return array.front()

func _on_Timer_timeout():
	$Timer.wait_time = choose([0.5, 1])
	state = choose(states)

func attack_start():
	attacking = true
	$AnimatedSprite.play("attack")
	$AttackSound.play()
	$AttackArea/CollisionShape2D.disabled = false
	$AnimatedSprite.connect("animation_finished", self, "attack_stop")
	
func throw_attack_start():
	attacking = true
	$AnimatedSprite.play("throw")
	$AttackSound.play()
	var throw = throw_scene.instance()
	get_parent().add_child(throw)
	throw.direction = direction
	throw.position = $ThrowPosition.global_position
	$AnimatedSprite.connect("animation_finished", self, "throw_attack_stop")

func attack_stop():
	attacking = false
	$AttackArea/CollisionShape2D.disabled = true
	$AnimatedSprite.disconnect("animation_finished", self, "attack_stop")
	state = MOVE

func throw_attack_stop():
	attacking = false
	$AnimatedSprite.disconnect("animation_finished", self, "throw_attack_stop")
	state = MOVE

func _on_AttackArea_body_entered(body):
	if(body.is_in_group('Player')):
		body.health -= damage
