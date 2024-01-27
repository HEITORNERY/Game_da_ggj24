extends Node2D

func _ready() -> void:
	$AudioStreamPlayer2D.play()
	
	for button in get_tree().get_nodes_in_group('button'): # Acessar cada botão
			button.connect('pressed', self, 'on_button_pressed', [button.name])
			button.connect('mouse_exited', self, 'mouse_interaction', [button, 'exited'])
			button.connect('mouse_entered', self, 'mouse_interaction', [button, 'entered'])
			
func on_button_pressed(button_name: String) -> void:
	match button_name:
		'Button':
			var _changed_scene : bool = get_tree().change_scene("res://scenes/interface/credits/references.tscn")
			
func mouse_interaction(button: Button, type: String) -> void:
	match type: # Qunado o mouse estiver sobre o botão sua iluminação diminui e quando sair ela volta ao normal
		'exited':
			button.modulate.a = 1.0
		'entered':
			button.modulate.a = 0.5
