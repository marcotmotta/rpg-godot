extends KinematicBody2D

export (int) var gravity = 1500
export (int) var max_health = 100

onready var health = max_health

var velocity = Vector2()
var floor_normal = Vector2(0, -1)

func _ready():
	pass
	get_node("/root/Node2D/EnemyLifeBar").max_value = max_health
	get_node("/root/Node2D/EnemyLifeBar").value = health

func _physics_process(delta):
	get_node("/root/Node2D/EnemyLifeBar").value = health
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, floor_normal)
