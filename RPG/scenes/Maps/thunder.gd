extends AudioStreamPlayer

var fixed_time = 25

func _ready():
	randomize()

func _on_Timer_timeout():
	play()
	$Light2D/AnimationPlayer.play("thunder")
	var time = fixed_time + randi() % 10
	$Timer.wait_time = time
