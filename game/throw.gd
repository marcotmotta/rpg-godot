extends Area2D

var speed = 250
var damage = 10
var velocity = Vector2()
var direction = Vector2.LEFT

func _physics_process(delta):
	velocity.x = direction[0] * speed * delta
	translate(velocity)
	$AnimatedSprite.play("throw")

func _on_Area2D_body_entered(body):
	if(body.is_in_group('Player')):
		body.health -= damage
	queue_free()
