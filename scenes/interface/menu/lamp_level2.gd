extends Area2D

var on_lamp : bool = false

func _on_Lamp_body_entered(_body: Node) -> void:
	on_lamp = true
	$Alert.show()
func _on_Lamp_body_exited(_body: Node) -> void:
	on_lamp = true
	$Alert.hide()

func _process(_delta: float) -> void:
	if on_lamp and Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://scenes/interface/credits/credits.tscn")
		Global.level = 1
