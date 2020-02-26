extends MarginContainer

func _ready():
	$MenuSong.play();

func _on_Play_gui_input(event):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		get_tree().change_scene("res://Scene1.tscn")

func _on_MenuSong_finished():
	$MenuSong.play();

func _on_Quit_gui_input(event):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		get_tree().quit()
