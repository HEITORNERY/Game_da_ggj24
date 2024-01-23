extends KinematicBody2D # Tipo do objeto herdado é um objeto de física 2D

# Primeira coisa é criar uma classe que leva o nome do objeto, no caso o Player
class_name Player

# Agora vai ser guardada a referência a sprite do personagem, por meio de uma variável onready
# Variáveis onready são usadas para acessar objetos da cena
onready var player_sprite : Sprite = get_node("Texture") 
# Agora a variável player_sprite vai acessar o objeto do tipo Sprite como o nome Texture
# Com isso o código já tem conhecimento da textura do personagem e pode acessá-la

onready var wall_ray : RayCast2D = get_node("WallRay")
# Aqui é criado uma variável para acessar o objeto WallRay e conseguir acesso a suas propriedades

var velocity: Vector2 # Aqui é criada uma variável do tipo vetor de duas dimensões
# A primeira dimensão corresponde a x e segunda a y, ou seja, (x,y)

export(int) var speed 
# Agora tenho uma variável que pode ser modificada pelo inspector e será responsável pela velocidade do player

var jump_count : int = 0 # Essa é uma variável para contar os pulos e limitar a dois pulos pro personagem

var landing : bool = false # Essa é a variável para checar condição para o pouso

export(int) var jump_speed # Essa variável vai corresponder a velocidade do pulo

export(int) var player_gravity # Essa variável vai ser a gravidade aplicada ao personagem

# Agora vai ser criadas variáveis do mesmo tipo de landing, ou seja, boleanas com valor falso
# O motivo é o mesmo, elas serão usadas como condições para execução da animação relacionada a variável, no caso as animações de ataque, agachar e defender
var attacking : bool = false
var defending : bool = false
var crouching : bool = false

# Além das variáveis para as condições de realizar a animação correspondente, ainda precisa de uma variável para checar quando a situação de ataque, defesa ou agachar estiver em execução, a movimentação do personagem não vai ocorrer
var can_track_input : bool = true

var on_wall : bool = false # Essa é a variável para checar se o personagem está na parede

var not_on_wall : bool = true # é outra variável para checar se o personagem está na parede

export(int) var wall_jump_speed # Essa variável é pro pulo quando o personagem está na parede

export(int) var wall_gravity # Essa variável é para gravidade, ou seja, a velocidade de deslize na parede

export(int) var wall_impulse_speed # Essa variável vai aplicar uma velocidade contrária a posição da parede, ou seja, se o personagem estiver deslizando na parede da esquerda o impulso vai jogar ele para direita

var direction : int = 1 # Essa variável começa com 1, pois o personagem está olhando para a direita no começo

var on_hit : bool = false # Variável que checa se está levando dano 

var dead : bool = false # Variável que checa se a morte vai acontecer

onready var stats : Node = get_node("Stats") # Guardar referência ao objeto com o status do player

# Criar uma constante para estar instanciando o feitiço
const SPELL : PackedScene = preload('res://scenes/player/spell_area.tscn')

export(int) var magic_attack_cost # Variável pro custo de mana, ao lançar um ataque mágico

# Criar a variável de offset do feitico
var spell_offset : Vector2 = Vector2(100, -50)
# O valor de 100 pode virar -100, mas o -50 é fixo

# Precisa-se de uma função que possa trabalhar com essas variáveis e aplicar essa física de movimento
# Para isso existe a physics_process
func _physics_process(delta: float):
	# Como essa função é uma função de update da Godot, ela é executada a cada frame
	# Será colocado dentro dessa função outras funções para serem executadas e verificadas a cada frame
	# A primeira é a de movimento na horizontal
	horizontal_movement_env()
	
	# Agora precisa-se de uma função para fazer o personagem andar sobre o solo usando a velocity
	# Essa função é a move_and_slide
	velocity = move_and_slide(velocity, Vector2.UP)
	# A função move and slide faz o personagem parar ao entrar em contato com uma colisão
	#Assim num pulo, o player para ao colidir em uma parede passa a ter velocidade = 0
	# Ou seja a move and slide vai lidar com a movimentação e colisão do player
	# Precisa-se corrigir o pulo do player, pois na move and slide, sem um vetor para apontar a direção do teto, ele não sabe onde é o chão e tudo para ele é parede
	# Para corrigir isso, basta fornecer um segundo parâmetro conhecido como vector2,up, que é um vetor (0, -1), com isso agora,a move and slide sabe para onde fica o teto, e o que está no sentido contrário é o chão
	player_sprite.animate(velocity) # Isso daqui é um método que vai ser acessado de Texture, mas ele precisa ser criado em Texture
	
	# Criar uma função similar a horizontal, mas na vertical
	vertical_movement()
	# Precisa-se de uma função para lidar com a gravidade 
	gravity(delta)
	actions_env() # Essa função vai atuar como a horizontal_movement e a vertical, ou seja, ela vai ser responsável pelas ações do personagem, nesse caso as ações de ataque, defesa, agachar
	
func horizontal_movement_env() -> void:
	# Criou-se a função de movimento na horizontal
	# E é uma função do tipo vazia, pois não retorna nada
	
	# Aqui será criado uma variável para lidar com o pressionar das teclas pelo jogador
	var input_direction : float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")# Detecta a ação de pressionar as setas
	# Essa variável vai retornar de 0 se nada for pressiondo e 1 se for pressionado para ir para direita
	# Do mesmo jeito para a tecla da esquerda, só que como tem o - antes fica negativop
	# Assim se a seta da esquerda for presiionada sozinha vai ficar -1 e o personagem vai pra esquerda
	# Se for 0, não vai ter movimento, ou porque nenhuma tecla foi apertada, ou por ambas serem apertadas
	
	# Agora já definimos a direção pro movimento, precisa-se associar ela a velocidade
	if can_track_input == false or attacking: # Aqui se o jogador estiver realizando alguma ação como agachar, defender ou atacar, ele vai estar realizando a ação e não será possível movimentá-lo
		velocity.x = 0
		return # Isso daqui faz com que enquanto essa condição estiver sendo realizada vai ser 0 a velocidade em x e nunca vai chegar a ser speed, a menos que essa condição seja falsa
	velocity.x = input_direction * speed
	# Agora a velocidade em x vai ser baseda no valor de speed e a direção na input_direction

func vertical_movement() -> void:
	# Primeira verificação é se o personagem está no solo
	if is_on_floor() or is_on_wall(): # Is on wall verifica se o personagem está colidindo com uma parede
		jump_count = 0 # Significa que ele pode pular, pois ainda não começou a contar os pulos
		# O jump count ser 0, enquanto o player está na parede permite realizar vários pulos na parede
		
	var jump_condition : bool = can_track_input and not attacking # Aqui é uma condição pro pulo a mais, que é não estar realizando nenhuma ação de ataque, agachar ou defender
	if Input.is_action_just_pressed("ui_select") and jump_count < 2 and jump_condition: # Se a tecla de espaço foi pressionada e ainda não pulou 2 vezes
		jump_count += 1 # Somar 1 ao contador de pulos
		
		if next_to_wall() and not is_on_floor(): # Next to wall é uma função que vai detectar quando o personagem estiver numa parede e tiver apertado a tecla de pulo
			velocity.y = wall_jump_speed # Aqui o personagem está saindo da parede com a velocidade de seu pulo para cima
			velocity.x += wall_impulse_speed * direction # Aqui com o pulo o personagem vai estar sendo impulsionado para frente
		else:
			velocity.y = jump_speed # Adicionar a velocidade de pulo ao personagem
	
func gravity(delta: float) -> void:
	
	if next_to_wall(): # Aqui é verificado se a função next to wall é true, vai ser executada a gravidade da parede no personagem
		velocity.y += delta * wall_gravity
		if velocity.y >= wall_gravity: # Aqui limita-se a gravidade na parede a um valor constante
			velocity.y = wall_gravity
		
	else:
		# A gravidade vai ser aplicada o tempo todo sobre o personagem, sempre que o personagem estiver fora da parede 
		velocity.y += delta * player_gravity
		
		# Que numa queda a gravidade pode acelerar o player até demais, e na queda prefere-se que a gravidade seja constante
		if velocity.y >= player_gravity:
			velocity.y = player_gravity

func actions_env() -> void:
	# Dentro da actions vai ter funções para lidar com cada ação, sendo elas ataque, defesa, agachar
	attack()
	defense()
	crouch()

func attack() -> void:
	# Criar uma variável de condição pro ataque acontecer
	var attack_condition : bool = not attacking and not defending and not crouching and is_on_floor()
	# Como todas as variáveis attacking, defending e crouching são false, logo attack condition vira true
	# Assim a variável de condição do ataque sendo verdadeira, o ataque pode ocorrer
	# Se qualquer uma das variáveis for true, a negação fica false e ataque não será realizado
	# A condição pro ataque é attack_condition ser true, o personagem estar no chão e a tecla de ataque ser pressionada
	if Input.is_action_just_pressed('attack') and attack_condition:
		attacking = true # Todas as condições satisfeitas, vai ter ataque
		player_sprite.normal_attack = true # O ataque usado vai ser o normal 
		
	# Criado a condição pro ataque mágico, que por padrão é a mesma condição do ataque físico
	# Além disso o jogador deve ter mana suficiente para o ataque mágico
	elif Input.is_action_just_pressed('magic_attack') and attack_condition and stats.current_mana >= magic_attack_cost:
		attacking = true # Personagem vai atacar
		player_sprite.magic_attack = true # Vai ser usado o ataque mágico
		spawn_spell()
		stats.update_mana('Decrease', magic_attack_cost) # Reduza a mana, de acordo com o custo do ataque mágico
		

func defense() -> void: # Para a função de defesa, o princípio é o mesmo da de agachar
	if Input.is_action_pressed('defense') and is_on_floor() and not crouching: # Aqui a tecla de defesa foi pressionada ou segurada e o personagem está no chão e não agachou, então pode realizar essa ação de defesa
		defending = true # Defesa pode acontecer, pois todos os requisitos foram atendidos
		can_track_input = false # Aconteceu uma ação, então para de rastrear ações
		stats.shielding = true # O escudo está ativado
		
	elif not crouching: # A condição paralela a defesa é agachar
		# A defesa não foi pressionada, mas o agachamento não ocorreu
		# Nesse caso a defesa está falsa e o rastreio deve estar falso também, pois nenhuma das situações seja defesa ou agachar está ativa
		defending = false 
		can_track_input = true 
		player_sprite.shield_off = true # Aqui a defesa não está ativa, logo a defesa está livre para ser usada
		stats.shielding = false # O escudo não é ativado ao agachar
		
func crouch() -> void:
	# Aqui vai seguir o mesmo princípio da condição de ataque, com uma diferença, que se for pressionada e manter pressionada a animação de agachado vai ser executada, enquanto estiver pressionado
	# Além disso, tem a condição de estar no chão para realizar o ataque, pois não tem animação do personagem atacando no ar
	if Input.is_action_pressed('crouch') and is_on_floor() and not defending:
		crouching = true
		can_track_input = false # Significa que a função de rastreio agora está desabilitada, pois foi executada uma ação, no caso a de agachar
		stats.shielding = false # O escudo não é ativado ao agachar 
	
	elif not defending: # Não está defendendo é condição para que o rastreio de ações do personagem volte a funcionar para identificar ações do player 
		crouching = false # Aqui o personagem não vai estar no caso de agachar, então vai ser falso o agachamento
		can_track_input = true # O rastreio de ações vai procurar pelas ações disponíveis, sabendo que não está ativa a condição de agachar, nem de defender
		player_sprite.chrouching_off = true # Aqui o agachamento não está ativo, logo agachar está livre para ser usado
		stats.shielding = false # O escudo não é ativado ao agachar 

func next_to_wall() -> bool: # Essa função retorna sim ou não para o personagem estar colidindo com a parede e assim poder aplicar o pulo da parede
	if wall_ray.is_colliding() and not is_on_floor(): # Aqui vai detectar se o raio está colidindo com uma parede e se o personagem está no ar
		if not_on_wall: # Quando o personagem pula e colide com a parede, devido a força de seu pulo, ele bate e sobe, mas assim que ele colidir a animação de deslizar na parede vai começar, então ele vai etr que diminuir sua velocidade para 0 para não subir e logo em seguida vai estar submetido a gravidade da parede
			velocity.y = 0 # Aqui o personagem não sobe mais, só desliza na parede
			not_on_wall = false # Agora o personagem está na parede, então essa variável é false agora
			# Assim que ele executar esse código ele vai sair, pois o not_on_wall é falso agora, assim ele só ficou sem velocidade para grudar na parede, e no instante depois de grudar já vai estar submetido a gravidade do deslize
			
		# mesmo que o not_on_wall seja falso no começo, a função ainda vai retornar true, pois o player está fora do solo e colidindo com uma parede
		return true
		
	else: # Aqui vai resetar o not_on_wall para que possa identificar outra parede e grudar o personagem nela
		not_on_wall = true
		return false # Aqui é para caso o meu personagem não esteja no ar, ou não esteja colidindo com uma parede, a função vai ser falsa
		# Assim com o personagem no chão ou sem colidir com a parede, não vai ter animação de deslize na parede ou gravidade do deslize
		
# Criado a função de spawnar o feitiço
func spawn_spell() -> void:
	# Criado a variável para chamar o script do feitiço
	var spell : FireSpell = SPELL.instance() # A variável recebe uma instância da cena de feitiço
	
	# Associado a spell o dano do ataque mágico, com base no poder do personagem
	spell.spell_damage = stats.base_attack_magic + stats.bonus_magic_attack
	
	# Mudar a posição de spawnar o feitiço
	spell.global_position = global_position + spell_offset
		
	# Adiciona o feitiço como filho da cena
	get_tree().root.call_deferred('add_child', spell)
	
	
	
