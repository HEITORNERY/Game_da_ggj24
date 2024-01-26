extends Label

class_name LevelUpdate

onready var timer : Timer = get_node("Timer")

func _process(delta: float) -> void:
	if Global.level == 2:
		text = Global.level_up
		yield(get_tree().create_timer(1), "timeout")
		text = ''
		yield(get_tree().create_timer(0), "timeout")
		text = ''
	if Global.level == 3:
		text = Global.level_up
		yield(get_tree().create_timer(1), "timeout")
		text = ''
		yield(get_tree().create_timer(0), "timeout")
		text = ''
	if Global.level == 4:
		text = Global.level_up
		yield(get_tree().create_timer(1), "timeout")
		text = ''
		yield(get_tree().create_timer(0), "timeout")
		text = ''
	if Global.level == 5:
		text = Global.level_up
		yield(get_tree().create_timer(1), "timeout")
		text = ''
		yield(get_tree().create_timer(0), "timeout")
		text = ''
	if Global.level == 6:
		text = Global.level_up
		yield(get_tree().create_timer(1), "timeout")
		text = ''
		yield(get_tree().create_timer(0), "timeout")
		text = ''
	if Global.level == 7:
		text = Global.level_up
		yield(get_tree().create_timer(1), "timeout")
		text = ''
		yield(get_tree().create_timer(0), "timeout")
		text = ''
	if Global.level == 8:
		text = Global.level_up
		yield(get_tree().create_timer(1), "timeout")
		text = ''
		yield(get_tree().create_timer(0), "timeout")
		text = ''
	if Global.level == 9:
		text = Global.level_up
		yield(get_tree().create_timer(1), "timeout")
		text = ''
		yield(get_tree().create_timer(0), "timeout")
		text = ''
