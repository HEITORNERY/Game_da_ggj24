extends Control

func get_drag_data(_position: Vector2):
	var data : Dictionary = {'sprite': $sprite.texture, 'amount': $amount.text, 'backup': self}
	var preview = self.duplicate()
	preview.get_node("background").hide()
	preview.get_node("amount").hide()
	preview.get_node("sprite").rect_position = -preview.rect_size / 2
	set_empty_slot()
	set_drag_preview(preview)
	return data

func can_drop_data(_position: Vector2, _data) -> bool:
	return true
	
func drop_data(_position: Vector2, data) -> void:
	if $sprite.texture == data.sprite:
		var drop_item : int = int($amount.text)
		drop_item += int(data.amount)
		$amount.text = String(drop_item)
	else:
		data.backup.get_node('sprite').texture = $sprite.texture
		data.backup.get_node('amount').text = $amount.text
		$sprite.texture = data.sprite
		$amount.text = data.amount

func set_empty_slot() -> void:
	$sprite.texture = null
	$amount.text = ''
