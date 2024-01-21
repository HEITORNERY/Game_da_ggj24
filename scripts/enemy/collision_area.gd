extends Area2D

# Dê o nome para o objeto, é a primeira coisa a fazer
class_name CollisionArea

# Guardar a referência ao objeto de tempo, ou seja, o temporizador
onready var timer : Timer = get_node('Timer') 

# Vai precisar de 2 variáveis, uma para a vida do inimigo e outra pro tempo de invencibilidade do inimigo
export(int) var health
export(float) var invulnerability_timer

# Guardar a referência ao objeto pai do inimigo
export(NodePath) onready var enemy = get_node(enemy) as KinematicBody2D

func on_collision_area_entered(area): # Sinal que vai detectar a entrada do player na área de dano do inimigo
	if area.get_parent() is Player: # Aqui vai ser verificado se o objeto pai da área que entrou em contato é o Player
		
		var player_stats : Node = area.get_parent().get_node('Stats')
		# Essa variável vai acessar o objeto pai da área que entrou na área de colisão do inimigo
		# A partir do objeto pai é possível acessar qualquer filho, no caso o filho acessado vai ser o Stats
		# Pois em Stats está o valor do ataque do personagem
		
		var player_attack : int = player_stats.base_attack + player_stats.bonus_attack
		# Aqui vai ser acessado o valor de ataque do player 
		
		# Função para atualizar a vida do inimigo subtraindo o dano do player de sua vida
		update_health(player_attack)
		
func update_health(damage: int) -> void:
	health -= damage # A vida do inimigo vai ser subtraído do dano sofrido
	
	if health <= 0: # Condição de morte do inimigo
		enemy.can_die = true # Flag de morte do inimigo
		return # Para a execução do código, que está baixo
		
	enemy.can_hit = true # O inimigo não está com sua vida zerada ou negativa, então leva o dano
	
		
