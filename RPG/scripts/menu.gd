extends CanvasLayer

onready var scene_changer = get_node("/root/scene_changer")

func _on_Play_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		scene_changer.change_scene("res://scenes/Maps/Map1.tscn")

func _on_Quit_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		get_tree().quit()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade":
		$Fade.queue_free()
