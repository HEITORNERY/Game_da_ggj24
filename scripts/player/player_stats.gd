extends Node

# Primeiro crie uma classe com o nome do script
class_name PlayerStats

# Criar uma variável para guardar o caminho para Player e acessar suas propriedades
export(NodePath) onready var player = get_node(player) as KinematicBody2D

# Guardar referência a collision area, pois precisa-se da referência a ela para poder desabilitá-la e reabilitar depois de um tempo
export(NodePath) onready var collision_area = get_node(collision_area) as Area2D

# Guardar referência ao timer
onready var invencibility_timer : Timer = get_node("InvencibilityTimer")

# A variável shielding vai ser um boleano e falso, pois no começo o personagem não está com a defesa ativa
# Quando a defesa for ativa shielding vai ser true e assim o dano recebido vai ser subtraído do escudo do personagem
var shielding : bool = false

# Precisa-se de variáveis pros atributos ou status do personagem
# Essas variáveis são de ataque normal, ataque mágico, defesa básica, vida do personagem e sua mana
var base_health : int = 15
var base_mana : int = 10
var base_attack : int = 1
var base_attack_magic : int = 3
var base_defense : int = 1

# Além dos atributos básicos, o personagem vai ter bônus provenientes de itens ou equipamentos
var bonus_health : int = 0
var bonus_mana : int = 0
var bonus_attack : int = 0
var bonus_magic_attack : int = 0
var bonus_defense : int = 0

# Precisa-se de variáveis para armazenar a vida atual do personagem e sua mana, pois ao subir de nível ele muda esse valor, ou seja, precisa-se de variáveis que guardem o mínimo de vida e mana para o nível do personagem
var current_health : int
var current_mana : int

# Quando o personagem conseguir itens que aumentem sua mana e vida é preciso armazenar esse novo valor de vida e mana
# OU seja uma variável que guarde a soma da vida atual e da mana atual acrescido do bônus
var max_mana : int
var max_health : int

# Vai ser necessário armazenar a experiência atual do personagem, pois com ela que sobe-se de nível
var current_exp : int = 0

# Além disso, precisa-se de uma variável pro nível do personagem, que vai começar no 1
var level : int = 1

# Vai ser preciso de uma variável do tipo dicionário para armazenar as informações do nível
var level_dict : Dictionary = {
	'1': 25, # Aqui no dicionário o valor entre aspas corresponde ao nível e o número inteiro a experiência para subir para o próximo nível
	'2': 33,
	'3': 49,
	'4': 66,
	'5': 93,
	'6': 135,
	'7': 186,
	'8': 251,
	'9': 356
}

onready var level_up_sound : AudioStreamPlayer2D = get_node("WowFX")

# Acessar o caminho da cena da popup
export(PackedScene) onready var floating_text

# Agora na função ready, vai ser declarado valores para as variáveis que estão sem valor 
func _ready():
	current_mana = base_mana + bonus_mana # A mana atual é a soma da mana inicial e os bônus adquiridos
	max_mana = current_mana # AQui o máximo de mana vai ser o tanto de mana que tem no momento
	current_health = base_health + bonus_health # A vida atual é a soma da vida inicial e os bônus adquiridos
	max_health = current_health # AQui o máximo de vida vai ser o tanto de vida que tem no momento
	
	# Aqui vou estar acessando o grupo da barra, para poder inicializar a barra com os valores de staus do personagem
	get_tree().call_group('bar_container', 'init_bar', max_health, max_mana, level_dict[str(level)])

# Aqui vai ser criado uma função para atualizar a experiência do personagem
func update_exp(value: int) -> void: # Essa função precisa receber um valor do tiṕpo inteiro, pois a experiência é um valor do tipo inteiro
	current_exp += value # AQui quando a função de atualizar experiência for chamada, a  experiência atual vai ser somado o valor de value
	# Aqui chama-se a função de spawnar a popup com o valor da exp atualizado
	spawn_floating_text('+', 'Exp', value)
	
	# Aqui vai ser chamado o grupo da barra de exp, pois o método de atualizar a barra de exp vai precisar ser chamado aqui, antes de executar a verificação de subir de nível
	get_tree().call_group('bar_container', 'update_bar', 'ExpBar', current_exp) # Isso daqui atualiza a barra de exp com a xp atual recebida ao derrotar o inimigo
	
	# Condição de aumentar o nível com base na experiência
	if current_exp >= level_dict[str(level)] and level < 9: # Aqui verifica se a experiência é suficiente para subir pro outro nível
		var leftover : int = current_exp - level_dict[str(level)] # Aqui a variável de resto vai armazenar o resto da subtração da mana atual pela mana necessária para subir de nível
		current_exp = leftover # Agora quando subir de nível o resto de experiência vai ser salvo pro personagem
		on_level_up() # Função para carregar as mudanças ao subir de nível
		level += 1 # Personagem gastou experiência, logo seu nível subiu uma unidade
		
		Global.level = level
		
		level_up_sound.play()
		
	elif current_exp >= level_dict[str(level)] and level == 9: #Situação de chegar no nível máximo
		current_exp = level_dict[str(level)] # Aqui a experiência vai ser igual ao valor de experiência máxima do nível 9
		# Ou seja, a experiência não aumenta mais a partir do máximo do nível 9
		
func on_level_up() -> void:
	# Quando o personagem sobe de nível sua vida carrega pro máximo e sua mana também
	current_mana = base_mana + bonus_mana
	current_health = base_health + bonus_health 
	
	# Aqui também precisa acessar o grupo da barra, pois vai precisar atualizar a barra com o novo valor, depois de subir de nível, ou coletar itens
	get_tree().call_group('bar_container', 'update_bar', 'ManaBar', current_mana) # Atualiza a barra de mana com o valor máximo pro nível e o bônus de mana caso tenha
	get_tree().call_group('bar_container', 'update_bar', 'HealthBar', current_health) # Atualiza a barra de vida com o valor máximo pro nível e o bônus de vida caso tenha
	
	# Adicionado um temporizador, para a exp chegar ao valor máximo e só depois desse tempo ser resetada
	yield(get_tree().create_timer(0.2), "timeout")
	
	#Aqui vai ser resetado a exp do personagem ao subir de nível pro valor desse nível e colocar a nova exp
	get_tree().call_group('bar_container', 'reset_exp_bar', level_dict[str(level)], current_exp) 

# AQui vai ser criado a função para atualizar a vida do personagem, seja quando receber dano ou usar um item
func update_health(type: String, value: int) -> void: # ESsa função precisa de uma string para determinar se o efeito é dano ou ganho de vida, além do valor a ser aumentado ou reduzido
	match type: # Aqui vai ser criado as condições de aumento ou redução de vida
		'Increase':
			current_health += value # Aqui adiciona o valor obtido pelo item na vida
			
			# Aqui chama-se a função de spawnar a popup com o valor da vida atualizado
			spawn_floating_text('+', 'Heal', value)
			
			# A vida do personagem, mesmo consumindo o item, não pode ultrapassar o valor máximo de vida pro nível
			if current_health >= max_health:
				current_health = max_health
				
		'Decrease':
			verify_shield(value) # Esse método vai verificar o escudo e o dano, fazer a subtração e retornar o valor de dano 
			if current_health <= 0: # Situação de morte do personagem
				player.dead = true # O método em player que valida a morte do personagem
			
			else: # Tomou dano e não morreu
				player.on_hit = true # On hit é a validação da situação de dano
				player.attacking = false # Durante o dano não pode-se atacar
				
	# Independente de ter perdido vida ou ganhado, a barra de vida precisa receber um valor e ser atualizada
	get_tree().call_group('bar_container', 'update_bar', 'HealthBar', current_health)
	# ESsa função só vai ser chamada depois do match, ou seja, caso alguma situação de ganho ou perda de vida for verificada, a função de update bar vai receber esse valor e jogar na barra
			
func verify_shield(value: int) -> void: # O valor aqui é o do dano do inimigo
	# Primeira condição é o personagem estar com escudo ativo
	if shielding: # Estando na defesa o dano vai ser decrescido do valor da defesa 
		if (base_defense + bonus_defense) >= value: # Aqui é o caso de a defesa ser maior que o ataque
			return # Aqui o resto da função é interrompida a leitura, pois a condição acima foi validada
		
		# Criar uma variável pro dano e ela deve ser um valor absoluto, ou seja, um valor em módulo
# warning-ignore:narrowing_conversion
		var damage : int = abs((base_defense + bonus_defense) - value)
		current_health -= damage
		# Aqui chama-se a função de spawnar a popup com o valor da vida atualizado
		spawn_floating_text('-', 'Damage', damage)
		
	else: # Condição de não estar com o escudo ativo durante o dano do inimigo
		current_health -= value # Tomou todo o dano do inimigo
		# Aqui chama-se a função de spawnar a popup com o valor da exp atualizado
		spawn_floating_text('-', 'Damage', value)
		
func update_mana(type: String, value: int) -> void: # A mana vai ter duas opções que é aumentar e diminuir
	# Cada opção vai ter um valor correspondente
	
	match type: # Criar as condições de ganho e perda de mana
		'Increase':
			current_mana += value # Adicionando o valor de mana obtido
			# Aqui chama-se a função de spawnar a popup com o valor da mana atualizado
			spawn_floating_text('+', 'Mana', value)
			if current_mana >= max_mana: # A mana não pode exceder o limite máximo
				current_mana = max_mana
			
		'Decrease':
			current_mana -= value
			# Aqui chama-se a função de spawnar a popup com o valor da mana atualizado
			spawn_floating_text('-', 'Mana', value)
			
	# Independente de ter perdido mana ou ganhado, a barra de mana precisa receber um valor e ser atualizada
	get_tree().call_group('bar_container', 'update_bar', 'ManaBar', current_mana)
	# ESsa função só vai ser chamada depois do match, ou seja, caso alguma situação de ganho ou perda de mana for verificada, a função de update bar vai receber esse valor e jogar na barra

# Função para testes de dano e morte
func _process(_delta):
	pass
	#if Input.is_action_just_pressed("hit"):
		#update_health('Decrease', 5)

func on_collision_area_entered(area): # VErificar se a área que entrou em contato com o personagem é a área de ataque do inimigo
	if area.name == 'EnemyAttackArea': # O nome da área do inimigo para verificação
		update_health('Decrease', area.damage) # Diminui a vida, com base no dano da área do inimigo 
		collision_area.set_deferred('monitoring', false) # Aqui vai ser desabilitado o monitoramento da área de colisão
		# Sem o monitoramento ativo, corpos entrando ou saindo da área não serão identificados pelo area
		invencibility_timer.start(area.invencibility_timer) # O tempo de invencibilidade vai variar de acordo com o tempo de ataque de cada inimigo
	
func on_invencibility_timer_timeout() -> void:# Método para verificar quando acabar o tempo de invencibilidade
	collision_area.set_deferred('monitoring', true)
	
func spawn_floating_text(type_sign: String, type: String, value: int) -> void:
	# A função precisa do sinal, da cor e do valor
	# Chamar o método de exibir o texto flutuante na tela
	var text: FloatText = floating_text.instance()
	
	# Atualizar a posição inicial da popup como a posição do player
	text.rect_global_position = player.global_position
	
	# Atualizar as variáveis da string da popup
	text.type = type
	text.type_sign = type_sign
	text.value = value
	
	# Adicionar o objeto a raiz da cena
	get_tree().root.call_deferred('add_child', text)
