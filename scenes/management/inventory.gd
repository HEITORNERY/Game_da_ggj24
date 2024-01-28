extends CanvasLayer

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		$inventory.visible = not $inventory.visible
