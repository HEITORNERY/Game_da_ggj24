extends CanvasLayer

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		$inventory.visible = not $inventory.visible
		
func add_item_inventory(sprite: Texture) -> bool:
	for slot in $inventory/container.get_children():
		if slot.get_node('sprite').texture == null:
			slot.get_node('sprite').texture = sprite
			slot.get_node('amount').text = '1'
			return true
			
	return false
			
