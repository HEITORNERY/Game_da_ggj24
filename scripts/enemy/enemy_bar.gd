extends Control

# Nome do script
class_name EnemyHealthBar

# Guardar referência ao tween
onready var tween : Tween = get_node("Tween")

# Guardar referência a barra de vida 
onready var health_bar : TextureProgress = get_node("BarBackground/HealthBar")

# Armazenar a vida atual do inimigo
var current_health : int 

# Função de iniciar a barra
func init_bar(bar_value : int) -> void:
	# Essa função recebe o valor inicial da barra
	# Para a barra iniciar é preciso que o objeto pai seja iniciado primeiro
	yield(get_parent(), "ready")
	
	# A barra inicia com o valor inicial como máximo
	health_bar.max_value = bar_value
	health_bar.value = bar_value
	current_health = bar_value
	
func update_bar(value: int) -> void:
	# Essa função atualiza a barra com o novo valor, após o dano
	call_tween(current_health, value) # Interpola do valor antigo pro novo valor
	current_health = value
	
func call_tween(old_value: int, new_value: int) -> void:
	# Essa função recebe um valor anterior de vida e faz uma interpolação pro novo valor
	var _interpolate_value : bool = tween.interpolate_property(health_bar, 'value', old_value, new_value, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
	# INicializa o tween
	var _start = tween.start()
	 
