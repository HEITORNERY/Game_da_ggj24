extends Control

# Dê um nome para esse script
class_name BarContainer

# Crie variáveis para armazenar referência as barras de vida, mana e experiência, além do objeto Tween
onready var tween : Tween = get_node("Tween")
onready var mana_bar : TextureProgress = get_node("ManaBarBackground3/ManaBar")
onready var health_bar : TextureProgress = get_node("HealthBarBackground/HealthBar")
onready var exp_bar : TextureProgress = get_node("ExpBarBackground2/ExpBar")

# Precisar armazenar os valores atuais de vida, mana e experiência do personagem
var current_health : int
var current_mana : int
var current_exp : int

# Criar uma função para inicializar a barra
func init_bar(health: int, mana: int, max_exp_value: int) -> void: # Essa função vai precisar da vida máxima do personagem, sua mana máxima e sua exp máxima
	# A diferença da barra de experiência para as outras é que ela começa com 0 e vai encher até o máximo de xp daquele nível
	# Armazenar os valores máximos de cada barra nas respectivas variáveis
	mana_bar.max_value = mana
	health_bar.max_value = health
	exp_bar.max_value = max_exp_value

	# Configurar o valor inicial de cada barra
	mana_bar.value = mana
	health_bar.value = health
	exp_bar.value = 0
	
	# Atualizar os valores atuais de cada barra
	current_health = health
	current_mana = mana
	current_exp = 0
	
# Função para aumentar a vida máxima e a mana máxima com o uso de itens, ou ao subir de nível
func increase_max_value(type: String, max_value: int, value: int) -> void:
	# Essa função precisa do nome do atributo a ser aumentado, seu valor máximo e seu valor atual
	match type: # Organizar os tipos em casos, ou seja, as possibiliades de aumento
		'Health':
			health_bar.max_value = max_value # Carrega o valor máximo
			health_bar.value = value # Verifica a vida da barra
			current_health = value # Atualiza o valor atual da vida 
			
		'Mana': # Aqui o princípio de aumento é o mesmo da barra de vida 
			mana_bar.max_value = max_value
			mana_bar.value = value
			current_mana = value
			
func update_bar(type: String, value: int) -> void:
	#Função para atualizar a barra visualmente
	# Precisa saber qual barra vai ser atualizada e o valor para atualizar na barra
	
	match type: # Cada barra vai ter um método para a atualização do valor real
		'HealthBar': 
			call_tween(health_bar, current_health, value) # Aqui é chamada a animação de atualizar a barra
			# Essa funão vai precisar dos argumentos, que é o tipo da barra, seu valor atual, que por padrão é o máximo, logo em seguida substituir esse valor pelo valor atual
			current_health = value
			
		'ManaBar': # A lógica para a barra de mana e exp vai seguir o memso método
			call_tween(mana_bar, current_mana, value)
			current_mana = value
			
		'ExpBar':
			call_tween(exp_bar, current_exp, value)
			current_exp = value
			
# Criado a função de resetar a exp e atulizar o valor de exp ao subir de nível
func reset_exp_bar(max_exp: int, value: int) -> void: # A função recebe o valor máximo de exp pro nível e o valor atual
	exp_bar.max_value = max_exp # A exp máxima é igual a exp máxima atualizada pro nível
	exp_bar.value = value # O valor de exp torna-se o valor atual
	current_exp = value # O valor atual é atualizado com value
	
	# Interpolar os valores com a call tween, para ter animação
	call_tween(exp_bar, 0, current_exp) # Atualizar a exp do valor 0, que é o início, pro valor atual de exp

# Criar a função de animação da barra
func call_tween(bar: TextureProgress, initial_value: int, final_value: int) -> void:
	# Essa função vai receber o objeto, referente a barra, o seu valor inicial e o valor final depois da alteração
	var _interpolate_property : bool = tween.interpolate_property(bar, 'value', initial_value, final_value, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT) # Função para interpolar, ou seja, trocar os valores da barra
			# Esse método de tween recebe o objeto, que é a barra, o tipo da propriedade para alterar, seu valor inicial e final e o tempo para fazer essa alteração
			# O Trans_Quad significa que a diminuição vai seguir a ordem de uma potência de 2, ou seja, vai diminuir ao quadrado, e o Ease in out, quer dizer que a diminuição vai ser lenta no começo e no fim
			
	# Precisa inicilizar o Tween, para poder dar proseguimento a interpolação
	var _start : bool = tween.start()
	
	# Foram criadas essa variáveis só para tirar o warning do debugger
	
	
		
