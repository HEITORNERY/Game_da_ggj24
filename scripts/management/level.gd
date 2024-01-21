extends Node2D

# Quando uma calsse é criada, esse script é renomeado para o nome dessa classe
class_name Level

# Guardar a referência ao player usando uma variável onready
onready var player : KinematicBody2D = get_node("Player")

# Chamar a função ready para executar o código de renascer 
func _ready():
	var _game_over : bool = player.get_node("Texture").connect("game_over", self, 'on_game_over') # Aqui o objeto player é acessado
	# Dentro de player vai ser acessado a sua sprite, onde tem o signal de fim de jogo
	# Esse sinal vai ter como objeto alvo esse próprio objeto, que é o Level
	# Ele vai ser conectado dentro de on_game_over, que é um método que vai ser chamado, assim que a conexão forr feita
	
func on_game_over() -> void:
	var _reload : bool = get_tree().reload_current_scene() # Aqui é a variável para recarregar a cena, assim que morrer
