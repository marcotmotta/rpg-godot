extends Area2D

func _on_SwordHit_body_entered(body):
	if body.get_name() == "Enemy":
		print(body.get_name())
		#$CollisionShape2D.get_node("BloodSplash").emitting = true
		get_node("/root/Node2D/Enemy").health -= get_node("/root/Node2D/Player").damage
		print (get_node("/root/Node2D/Enemy").health)
	else:
		print("Fail...")
