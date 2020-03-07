extends RichTextLabel

var dialogue = ["Larry: vc éh um lixo kaakkaka", "Robert: voc q eh huehue"]
var page = 0

func _ready():
	set_bbcode(dialogue[page])
	set_visible_characters(0)
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if get_visible_characters() > get_total_character_count():
			if page < dialogue.size() - 1:
				set_visible_characters(0)
				page += 1
				set_bbcode(dialogue[page])
		else:
			set_visible_characters(get_total_character_count())

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
