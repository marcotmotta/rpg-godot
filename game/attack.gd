extends Area2D

func _on_SwordHit_body_entered(body):
	if body.get_name() == "Enemy":
		print(body.get_name())
	else:
		print("Fail...")
