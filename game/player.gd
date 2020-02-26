extends KinematicBody2D

export (int) var run_speed = 300
export (int) var jump_speed = -700
export (int) var gravity = 1500
export (int) var max_health = 100
export (int) var damage = 10

var velocity = Vector2()
var floor_normal = Vector2.UP
var jumping = false
var attacking = false

onready var health_bar = get_node('/root/Node2D/PlayerLifeBar')
onready var health = max_health

func _ready():
	health_bar.max_value = max_health
	health_bar.value = health

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('right')
	var left = Input.is_action_pressed('left')
	var jump = Input.is_action_just_pressed('up')
	var attack = Input.is_action_just_pressed('attack')

	if !attacking:
		if attack:
			player_attack_start()
		else:
			if jump and is_on_floor():
				jumping = true
				velocity.y = jump_speed
				$JumpSound.play();
			if right:
				velocity.x += run_speed
				$AnimatedSprite.set_flip_h(false)
				$SwordHit.scale = Vector2(abs($SwordHit.scale.x), $SwordHit.scale.y)
			if left:
				velocity.x -= run_speed
				$AnimatedSprite.set_flip_h(true)
				$SwordHit.scale = Vector2(-abs($SwordHit.scale.x), $SwordHit.scale.y)

			if velocity.x != 0:
				$AnimatedSprite.play("run")
			else:
				$AnimatedSprite.play("idle")

func _physics_process(delta):
	health_bar.value = health
	get_input()
	velocity.y += gravity * delta
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity, floor_normal)

func player_attack_start():
	attacking = true
	$AnimatedSprite.play("attack")
	$AttackSound.play()
	$SwordHit/CollisionShape2D.disabled = false
	$AnimatedSprite.connect("animation_finished", self, "player_attack_stop")

func player_attack_stop():
	attacking = false
	$SwordHit/CollisionShape2D.disabled = true
	$AnimatedSprite.disconnect("animation_finished", self, "player_attack_stop")


func _on_SwordHit_body_entered(body):
	if body.is_in_group("Enemies"):
		print(body.get_name())
		body.health -= damage
		print (body.health)
	else:
		print("Fail...")
