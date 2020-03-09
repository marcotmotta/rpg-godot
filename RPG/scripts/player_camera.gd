extends Camera2D

const LOOK_AHEAD_FACTOR = 0 #0.05
const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 1.5

var facing = 0

onready var prev_camera_pos = get_camera_position()
onready var tween = $ShiftTween

func _process(delta):
	_check_facing()
	prev_camera_pos = get_camera_position()

func _check_facing():
	#var new_facing = sign(get_camera_position().x - prev_camera_pos.x)
	var new_facing = get_parent().facing
	if new_facing != 0 and facing != new_facing:
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * facing

		tween.interpolate_property(self, "position:x", position.x, target_offset, SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
		tween.start()

func _on_Player_grounded_updated(is_grounded):
	drag_margin_v_enabled = !is_grounded
