extends Label

onready var level_up_sound : AudioStreamPlayer2D = get_node("WOwFX")

func _process(_delta: float) -> void:
	text = String(Global.level)
