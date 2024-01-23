extends KinematicBody2D

# Criado o nome do script, por meio de uma classe
class_name EnemyTemplate 

# Criar uma variável para guardar referência a textura do inimigo
onready var texture : Sprite = get_node("Texture") 

# GUardar refer}encia ao floor raycast 
onready var floor_ray : RayCast2D = get_node("FloorRay")

# Guardar a referência ao animationplayer
onready var animation : AnimationPlayer = get_node("Animation")

# Assim como o player, o inimigo vai armazenar algumas variáveis de condições de ações
var can_die: bool = false # Condição de morte pro inimigo
var can_hit: bool = false # Condição para levar dano
var can_attack: bool = false # Condiçãop para atacar  

# Precisa-se de uma variável para armazenar a velocidade, assim como pro player
var velocity: Vector2 

# CRiar a variável para acessar player
var player_ref: Player = null # Esse nome Player é o nome que recebe o código dele, ou seja, é o nome do objeto Player via script
# Ele vai começar vazio, pois essa variável só vai ser acessada, quando o player entrar na área de detecção

export(int) var speed # Essa variável vai armazenar a velocidade do inimigo
export(int) var gravity_speed # Essa variável corresponde a gravidade aplicada ao inimigo
export(int) var proximity_threshold # Limite de proximidade do inimigo pro player, para parar de perseguir e atacar

# Declarar a variável para a posição padrão do raycast do solo
export(int) var raycast_default_position

# Declarado uma variável do tipo lista, para armazenar os itens dropados pelo inimigo
var drop_list : Dictionary

# Criar o multiplicador do número gerado pelo dado de probabilidade
# Por padrão, vai começar com 1, pois quando a probabilidade é pequena vai multiplicar o número do dado multiplicador por 1
var drop_bonus : int = 1

# Criando uma variável para a quantidade de exp fornecido pelo inimigo ao morrer
export(int) var enemy_exp 

# Chamar a função de atualizar o estado a cada frame
func _physics_process(delta: float) -> void:
	gravity(delta) # Função de gravidade
	move_behavior() # Função para realizar a movimentação na horizontal do inimigo
	verify_position() # Método para verificar a posição do inimigo
	texture.animate(velocity) # Isso daqui é para ir para o script de textura do inimigo
	# Lá vai acessar a função animate e vai fornecer a velocity como argumento
	# Pois existem animações que serão executadas com velocidade, como a de correr do inimigo
	
	# Adiconar a velocidade a função de movimentação sobre os blocos de colisão
	velocity = move_and_slide(velocity, Vector2.UP)
	
func gravity(delta: float) -> void:
	velocity.y += gravity_speed * delta # Adicionar a gravidade a cada frame
	
func move_behavior() -> void:
	if player_ref != null: # Condição de movimento para quando o Player for detectado
		var distance : Vector2 = player_ref.global_position - global_position # Isso daqui é um vetor que vai apontar para onde estar o player, em relação ao inimigo
		var direction : float = sign(player_ref.global_position.x - global_position.x) # Isso daqui é para transformar a distance em um valor entre -1 e 1, ou seja, um valor para direção
		if abs(distance.x) <= proximity_threshold: # Condição para o inimigo parar de perseguir e atacar
			velocity.x = 0 # Inimigo para de se movimentar, para atacar
			can_attack = true # Inimigo pode atacar
		
		elif floor_collision() and not can_attack: # Condição de ainda estar no chão, mas não perto o bastante do player
			velocity.x = direction * speed # A velocidade de perseguição continua na direção do player

		else: # Condição de não estar encontrando o chão
			velocity.x = 0 # Parar para não cair
			
		return # Aqui encerra o código, ou seja, tudo abaixo na função será ignorado
		
		# O else pro primeiro if não é necessário, pois o return impede, que o que esteja abaixo seja executado, se a condição do if for validada
		
	velocity.x = 0 # O inimigo não identificou o Player, então ele vai ficar parado
	
func floor_collision() -> bool: # Essa é uma função de retorno de boleano para a colisão com o chão
	if floor_ray.is_colliding():
		return true # SE estiver colidindo o Raycast com o solo, então o personagem ainda está no solo
	return false # Caso a única condição for inválida, retorne falso
	 
func verify_position() -> void:
	if player_ref != null: # Verificando se o player entrou na área de perseguição
		var direction : float = sign(player_ref.global_position.x - global_position.x)
		# O sign ele considera o sinal, ou seja, se for positivo retorna +1 e se for negativo retorna -1
		
		if direction > 0:
			texture.flip_h = true # Pois aqui o inimigo começa olhando para esquerda e se o flip h for ativado, ele vai virar para direita, que é onde o player está
			floor_ray.global_position.x = abs(raycast_default_position) # O raycast do solo vai mudar de posição com o virar do personagem
			# O raycast por padrão está no sentido negativo no começo, então ele vira pro sentido positivo, mas o módulo é o mesmo
			# POr isso o abas para pegar o módulo e atribuir a position do raycast ao virar

		elif direction < 0: # O personagem está a esquerda do inimigo
			texture.flip_h = false # O inimigo já está virado para esquerda, por padrão
			floor_ray.global_position.x = raycast_default_position # O raycast é negativa para esse caso, pois está virado para esquerda
			
func kill_enemy() -> void: # Função para morte do inimigo
	animation.play('kill') # Iniciar a animação de kill
	
	# O inimigo vai ter um método a ser chamado, depois que morrer, isso vai estar em todos os inimigos
	spawn_item_probability()
	
	# Vai ser atualizado a exp, após a morte do inimigo e cada inimigo terá a sua exp liberada
	get_tree().call_group('player_stats', 'update_exp', enemy_exp)
	
func spawn_item_probability() -> void: 
	# Aqui dentro vai ser rodado um dado de 0 a 20, que vai ser multiplicado por um multiplicador de drop, no qual, vai ser correspondente a porcentagem de drop desse item
	var random_number : int = randi() % 21
	
	if random_number <= 6: # Configura a menor probabilidade
		drop_bonus = 1 # O bônus de drop multiplicador é 1
	
	elif random_number >= 7 and random_number <= 13:
		drop_bonus = 2 #
		
	else:
		drop_bonus = 3
		
	
	for key in drop_list.keys(): # Aqui vai ser acessado cada chave da drop list e vai verificar suas propriedades
		var rng : int = randi() % 100 + 1 # Aqui vai ser gerado um número entre 0 e 100, pois a probabilidade de drop de cada item é um valor entre 0 e 100%
		if rng <= drop_list[key][1] * drop_bonus: # Aqui verifica se o número aleatório gerado pelo dado e pela multiplicação do drop é menor ou igual a porcentagem do item da lista de drop, baseado nas chaves e na porcentagem de cada chave
			# Caso a condição seja satisfeita, o item é dropado
			var item_texture : StreamTexture = load(drop_list[key][0])# Aqui é uma variável do tipo stream texture serve para carregar uma imagem já salva na memória
			 # Agora a stream texture vai acessar a drop list e vai pegar o caminho da imagem do item e vai carregá-lo na cena 
			var item_info : Array = [drop_list[key][0],drop_list[key][2],drop_list[key][3],drop_list[key][4], 1]# Essa variável vai armazenar todas as outras informações do item, que não é seu caminho na memória, para que o personagem possa acessá-los
			# O último valor de 1 é referente a quantidade de itens a ser dropado do tipo especificado na item info
			
			spawn_physic_item(key, item_texture, item_info) # Método para spawnar o item físico no cenário
			# Para o item ser spawnado precisa da chave, que corresponde ao nome do item, do seu caminho, além de suas informações, por isso o uso de key, item texture e item info
			
func spawn_physic_item(key: String, item_texture: StreamTexture, item_info: Array) -> void:
	var physic_item_scene = load('res://scenes/env/physic_item.tscn') # Aqui vai ser carregada a cena do item
	var item : PhysicItem = physic_item_scene.instance() # AQui vai ser chamado o objeto do item, pois a cena precisa que o objeto seja carregado e esteja ṕpronto, antes de rodar o código de spawnar o item
	get_tree().root.call_deferred('add_child', item) # AQui vai ser acessada a árvore da cena, e vai adicionar o objeto do item como filho dela
	# Assim evita-se que os itens dropados sejam deletados, após o monstro morrer
	
	item.global_position = global_position # O item vai aparecer, a partir da posição de morte do monstro e vai ser impulsionado de lá 
	
	item.update_item_info(key, item_texture, item_info) # AQui é fornecido as informações para a função de atualizar a informação do item, que está no physics item
	
