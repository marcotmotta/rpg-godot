extends RichTextLabel

var dialogue = \
	["vc é um esqueleto daohra pacas", \
	"mas vc bebeu demais noite passada e n lembra pq karalhos vc ta numa dungeoN", \
	"voc precisa dar um jeito de eskapar...", \
	"antes q o grande goblen te pegue !!!!!!!jj"]
var page = 0

func _ready():
	set_bbcode(dialogue[page])
	set_visible_characters(0)
	set_process_input(true)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if get_visible_characters() > get_total_character_count():
			if page < dialogue.size() - 1:
				set_visible_characters(0)
				page += 1
				set_bbcode(dialogue[page])
			else:
				# provisório
				var scene_changer = get_node("/root/scene_changer")
				scene_changer.change_scene("res://scenes/TestMap.tscn")
		else:
			set_visible_characters(get_total_character_count())

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
