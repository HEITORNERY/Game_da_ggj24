extends Node2D

# NOme para esse script
class_name EnemySpawner

# Guardar referência ao temporizador 
onready var spawn_timer : Timer = get_node("Timer")

# Um contador de inimigos
var enemy_count : int = 0

# Uma variável para armazenar uma lista com os tipos de inimigos e cada inimigo tem sua probabilidade de spawn
export(Array, Array) var enemies_list 

# Cada plataforma tem um nível de spwan diferente]
export(float) var spawn_cooldown

# Uma quantidade de inimigos a ser espalnados por plataforma
export(int) var enemy_amount

# Variáveis para dar a posição de spawn do inimigo
export(int) var left_gap_position
export(int) var right_gap_position

# Variável para permitir o inimigo respawnar, pois um boss não pode respawnar
export(bool) var can_respawn 

func _ready() -> void:
	randomize() # Gerar uma aleatoriedade para spawnar os inimigos
	spawn_enemy() # Função de spawn de inimigos
	
func spawn_enemy() -> void:
	enemy_count += 1 # Adiciona um inimigo
	var random_number: int = randi() % 100 + 1 # Gera uma probabilidade 0 a 100
	
	for enemy in enemies_list:
		if enemy[2] <= random_number and enemy[3] >= random_number:
			# Aqui verifica se a porcentagem está entre o valor mínimo e máximo
			# Verifica qual inimigo está nesse intervalo e spawn ele
			var enemy_instance = load(enemy[0]).instance()
			
			enemy_instance.connect('kill', self, 'on_enemy_killed')
			#aqui conecta a função de kill do inimigo a um método de execução após a morte do inimigo
			
			enemy_instance.global_position = Vector2(spwan_position(), enemy[1])
			# Aqui é spawnado o inimgo na posição definida pela spawn_position
			# Enemy no índice 1 é o offset do inimigo spawnado
			
			add_child(enemy_instance) # Adiciona o inimigo como filho desse nó
			
	if enemy_count < enemy_amount:
		spawn_timer.start(spawn_cooldown) # Sempre que o número de inimigos for menor que a quantidade do amount, então o temporizador para spawnar vai ser criado
			
func spwan_position() -> float:
	return rand_range(left_gap_position, right_gap_position) # VAI RETORNAR um valor entre o mínimo e o máximo de distância pro inimigo spawnar
	
func on_enemy_killed() -> void:
	enemy_count -= 1 # Inimigo morto subtrai um do número de inimigos da cena
	spawn_timer.start(spawn_cooldown) # Inicia o temporizador para spawnar o inimigo
	

func on_timer_timeout():
	pass # Replace with function body.


func on_spawner_timeout(): # Quando o temporizador chegar a 0, spawne um novo inimigo
	if can_respawn: 
		spawn_enemy()
