extends Sprite

# 1 - Crie uma classe para esse script com o nome do script relacionado
class_name PlayerTexture

# Criar o sinal para o fim de jogo
signal game_over

# 2 - Acessar uma informação de um objeto irmão, que no caso é o Animation, pois preciso das animações dele 
export(NodePath) onready var animation = get_node(animation) as AnimationPlayer
#3 - Eu estou criando animation, que vai armazenar o caminho para AnimationPlayer, e estou acessando esse objeto por meio da variável animation

export(NodePath) onready var player = get_node(player) as KinematicBody2D # Estou acessando o player e suas propriedades

export(NodePath) onready var attack_collision = get_node(attack_collision) as CollisionShape2D # Aqui estou criando uma variável para acessar a colisão do ataque, afim de desabilitar ela durante o hit do personagem

var shield_off : bool = false # Aqui a defesa não está desativada
var chrouching_off : bool = false # Aqui o agachamento está desativado
var suffix : String = '_right' # Aqui é para saber se a animação de ataque vai ser a da direita ou esquerda
var normal_attack : bool = false # Variável de condição para dar dano com o ataque da espada, ou seja, o ataque normal sem mana

# Aqui vai ser criado a variável para verificar se o ataque é do tipo mágico
var magic_attack : bool = false

# Guardar referência ao objeto de aúdio de hit do player
export(NodePath) onready var hit_sound = get_node(hit_sound) as AudioStreamPlayer2D

# 4 - Aqui vai ser criado a função animate, que vai receber velocity como argumento
# 5 - Aqui o argumento para animate pode ser qualquer nome, lá no código do player é usado velocity, pois essa é a variável lá
# 6 - Aqui pode ser direction essa variável e assim como lá, por ser uma velocidade, vai ser um vector2
func animate(direction: Vector2) -> void:
	verify_position(direction) # 7 - Basicamente essa é uma função para verificar para onde está olhando o player
	
	if player.on_hit or player.dead: # Condição para tomar dano ou morrer tem prioridade sobre movimentação e as outras animações
		hit_behavior() # Função para tratar das animações de morte e dano
		hit_sound.play() # Inicia o som de dano
	
	# Agora foi adicionado mais uma condição para executar uma ação, que é a de estar colado na parede
	elif player.attacking or player.defending or player.crouching or player.next_to_wall(): # Basta que ele esteja atacando ou defendendo ou agachado, que vai ser executado a ação correspondente
		action_behavior() # Essa é a função que vai lidar com as animações de ataque, defesa e agachar
		
	# 15 - Agora precisa-se adicionar as animações do pulo, queda e pouso
	# 16 - Para isso será criado uma condição, que verifica se a direction em y, que é a velocidade nesse script para y, é !=0
	# 17 - Caso seja positivo, então a animação deve ser de pulo ou queda
	elif direction.y != 0: # Esse elif é porque as animações de ação como atacar, defender e agachar tem prioridade sobre as animações de movimento
		vertical_behavior(direction) # Essa é a função que vai executar a animação de pulo e queda
	elif player.landing == true:
		animation.play('landing') # Aqui eu estou dando prioridade para a animação de pouso, em relação as animações de idle e run
		# Significa que ao cair e tocar o solo, a animação de pouso vai ser executada primeira
		# Porém a variável landing precisa voltar a ser falsa, assim que acabar a animação de pouso, para isso vai ser usado um sinal, que observa uma ação e executa uma ação, no caso queremos um sinal para quando uma animação parar, esse sinal vai estar em animationplayer
		player.set_physics_process(false) # Agora a física vai ser congelada, até a animação de pouso acabar
	else:
		horizontal_behavior(direction) # 8 - É a função que vai adicionar a animação de correr ao personagem, quando estiver em movimento
		
func verify_position(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false # 9 - Se a velocidade está positiva, então o personagem está olhando para direita
		suffix = '_right' # Aqui o personagem está olhando para direita, então o sufixo pro ataque é direita, assim o ataque a ser executado é o ataque com a direita
		position = Vector2.ZERO # Aqui eu vou colocar meu personagem na origem toda vez, que estiver olhando para a direita
		player.direction = -1 # Pois aqui a direção do impulso é contrária a direita, ou seja, negativo para a esquerda
		player.wall_ray.cast_to = Vector2(11.2, 0) # Aqui vai ser configurado para onde o raio da parede aponta, quando estiver olhando para direita 
		player.spell_offset = Vector2(100, -50) # Aqui o feitiço é instanciado a direita
		
	elif direction.x < 0:
		flip_h = true # 10 - Ele está com velocidae negativa, então está indo para esquerda, logo o personagem deve estar virado para essa direção
		suffix = '_left' # Aqui o personagem está olhando para esquerda, então o sufixo pro ataque é esquerda, assim o ataque a ser executado é o ataque com a esquerda
		position = Vector2(-2,0) # Isso daqui é para corigir a diferença entre a posição da espada do personagem e o limite da colisão do ataque
		player.direction = 1 # Pois aqui a direção do impulso é contrária a esquerda, ou seja, positivo para a direita
		player.wall_ray.cast_to = Vector2(-13.2, 0) # Aqui vai ser configurado para onde o raio da parede aponta, quando estiver olhando para esquerda vai ser 2 unidades maior, pois tem esse offset entre o limite da colisão e o braco do personagem 
		player.spell_offset = Vector2(-100, -50) # Aqui o feitiço é instanciado a esquerda

func horizontal_behavior(direction: Vector2) -> void:
	if direction.x != 0: # 11 - O personagem está em movimento
		animation.play('run') # 12 - Estar rodando a animação de run
	else: #13 - É o caso de o personagem estar parado
		animation.play('idle') # 14 - Rodar a animação de parado
		
func vertical_behavior(direction: Vector2) -> void:
	if direction.y > 0:
		player.landing = true # Aqui quando o personagem estiver caindo a landing vai ser ativada, assim quando o personagem tocar o solo, vai ser possível ativar essa animação de pouso
		animation.play('fall')
	elif direction.y < 0: 
		animation.play('jump')
	# Já para poder acessar a animação de queda, esse script da texture do personagem, precisa acessar o objeto player, pois é nele que está a variável landing
	# Para isso vai ser preciso criar uma variável nodepath que acesse player

func on_animation_finished(anim_name: String): # Aqui está o método para verificar sempre que uma animação terminar e ela recebe uma string, pois as animações são identificadas por frases
	match anim_name: # Criando a condição que verifica a animação como um caso e executa um código específico para esse caso
		'landing': # A primeira animação, no caso, o primeiro caso é a de pouso
			player.landing = false # Com a landing sendo falso, a condição de movimento na horizontal vai estar sendo executada, ou seja, acabou o pouso começa a animação de idle

# Agora quando o personagem cair e estiver executando a animação de pouso, ele não deve mover-se até a animação parar
# Para isso basta congeklar a física do personagem, para isso a physics process vai ser falsa
			player.set_physics_process(true) # Aqui a animação de pouso já parou e a física de movimento pode voltar a funcionar 
		
		'attack_right': # Aqui acabou a animação de ataque da direita
			player.attacking = false # Acabou o ataque, ou seja, pode atacar de novo
			normal_attack = false # O ataque normal já foi usado e fica disponível para ser usado de novo
		
		'attack_left': # Aqui acabou a animação de ataque da esquerda
			player.attacking = false # Acabou o ataque, ou seja, pode atacar de novo
			normal_attack = false # O ataque normal já foi usado e fica disponível para ser usado de novo
			
		'hit': # Caso de a animação de hit acabar
			player.set_physics_process(true) # Física volta a funcionar pro personagem
			player.on_hit = false # Acabou o dano e já pode voltar a tomar dano
			
			if player.defending: # Preserva o estado anterior antes do hit, significa que se estava defendendo e tomou hit, mas continuou segurando a tecla de defesa, então vai voltar para essa animação assim que acabar a animação de hit
				animation.play('shield')
				
			if player.crouching: # Estava agachado e levou hit
				animation.play('crouch') # Terminou a cena de hit volta pro estado de agachado, caso estivesse segurando a tecla de agachar
				
		'dead': # Após a animação de morte acabar, deve emitir um sinal de fim de jogo
			emit_signal('game_over') # Esse é o sinal de fim de jogo
			
		'spell_attack': # Após finalizar o ataque mágico o player pode atacar de novo
			player.attacking = false
			magic_attack = false
				
func action_behavior() -> void:
	
	# vai ser priorizado a next to wall, devido o simples fato de essa animação rodando, nehuma das outras de ataque, defesa e agachar poderão ser usadas
	if player.next_to_wall(): # Caso next to wall seja verdade, execute a animação de deslizar
		animation.play('wall_slide')
	
	elif player.attacking and normal_attack: # Aqui é a condição de atacar e de dar dano com o ataque normal 
		animation.play('attack' + suffix) # Executar a animação de atacar com o sufixo, que pode ser esquerda ou direita
		
	elif player.attacking and magic_attack: # Aqui verifica se o player está atacando e se o ataque é do tipo mágico
		animation.play('spell_attack') #Inicia-se a animação de ataque mágico
	
	elif player.defending and shield_off: # AQui é a situação para a defesa, que precisa do escudo desativado, ou seja, para defender não pode estar defendendo desde o início
		animation.play('shield')
		shield_off = false # Isso daqui é para quando a animação de defesa for realizada, ela vai ser realizada ao apertar e segurar a tecla de defesa, assim a animação só vai ser executada uma vez e vai congelar nela até a tecla ser liberada
		
	elif player.crouching and chrouching_off: # AQui é a situação para a agachar, que precisa do agachamento desativado, ou seja, para agachar não pode estar agachando desde o início
		animation.play('crouch')
		chrouching_off = false # Isso daqui é para quando a animação de agachar for realizada, ela vai ser realizada ao apertar e segurar a tecla de agachar, assim a animação só vai ser executada uma vez e vai congelar nela até a tecla ser liberada

func hit_behavior() -> void: # Essa função vai congelar a física do personagem durante o dano ou morte
	# Significa que durante o dano e a morte o personagem não poderá mover-se
	player.set_physics_process(false)
	attack_collision.set_deferred('disabled', true) # AQui está sendo desabilitada a colisão do ataque
	# A propriedade set_defered deve ser usada para desabilitar colisões e deve passar o nome disabled e um boleano
	
	if player.dead: # Condição de morte
		animation.play('dead') # Chama a animação de morte
		
# Quando tomar dano vai ser chamada a animação de hit
	elif player.on_hit: # Condição de dano
		animation.play('hit')
	
