extends Control

# Guardar referência ao menu 
onready var menu : Control = get_node("Menu")

# Guardar referência ao container dos botões
onready var button_container : VBoxContainer = get_node("Menu/ButtonContainer")

# Guardar referência ao botão de continuar
onready var continue_button : Button = button_container.get_node("Continue")

func _ready() -> void:
	$Sound.play()
	
	for button in get_tree().get_nodes_in_group('button'): # Acessar cada botão
		button.connect('pressed', self, 'on_button_pressed', [button.name])
		button.connect('mouse_exited', self, 'mouse_interaction', [button, 'exited'])
		button.connect('mouse_entered', self, 'mouse_interaction', [button, 'entered'])
	
func on_button_pressed(button_name: String) -> void:
	match button_name:
		'Play': # Aqui vai para a cena do level 1
			var _changed_scene : bool = get_tree().change_scene("res://scenes/management/level.tscn")
		'Quit': # Botão de fechar o jogo vai executar sua ação
			get_tree().quit()
			
func mouse_interaction(button: Button, type: String) -> void:
	match type: # Qunado o mouse estiver sobre o botão sua iluminação diminui e quando sair ela volta ao normal
		'exited':
			button.modulate.a = 1.0
		'entered':
			button.modulate.a = 0.5
			
