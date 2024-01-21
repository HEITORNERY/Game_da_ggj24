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
