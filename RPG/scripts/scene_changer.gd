extends CanvasLayer

# Caso necessario, um signal pra mudança de cena:
#signal scene_changed()

onready var animation_player = $AnimationPlayer
onready var black = $Control/ColorRect

func change_scene(path, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	get_tree().change_scene(path)
	animation_player.play_backwards("fade")
	#emit_signal("scene_changed")

# call it like that:
# onready var scene_changer = get_node("/root/scene_changer")
# scene_changer.change_scene("res://scenes/<scene>")
