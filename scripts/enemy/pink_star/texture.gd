extends EnemyTexture # Vamos herdar desse modelo, pois lá já tem funções prontas para serem usadas e as variáveis já definidas
# Como Enemy Texture já herda de sprite, o nosso código está herdando da mesma fonte

# Nomear esse objeto 
class_name PinkStarTexture

# Guardar referência ao som de hit
export(NodePath) onready var hit_sound = get_node(hit_sound) as AudioStreamPlayer2D

# Guardar referência ao som de morte do inimigo 
export(NodePath) onready var kill_sound = get_node(kill_sound) as AudioStreamPlayer2D

# Reescrever a função de animação
func animate(velocity: Vector2) -> void:
	if enemy.can_hit or enemy.can_die or enemy.can_attack: # Aqui vai ser as condições de chamar as animaçĩes de dano. morte e ataque do inimigo 
		action_behavior() # Função para lidar com as animações de dano e morte
		
	else: # AQui a animação de movimento só roda senão estiver levando dano ou morrendo
		move_behavior(velocity) # Função para liadar com a movimentação 
	
func move_behavior(velocity: Vector2) -> void:
	if velocity.x != 0: # Siggnifica que está ocorrendo perseguição
		animation.play('run')
	
	else: # O inimigo está parado
		animation.play('idle')
		
func action_behavior() -> void:
	if enemy.can_die: # A animação de morte tem prioridade sobre todas
		animation.play('dead')
		enemy.can_hit = false # Morreu não pode mais tomar dano
		enemy.can_attack = false # Morto não ataca
		kill_sound.play() # Toca o som de morte do inimigo
		attack_area_collision.set_deferred('disabled', true) # Garantir que o inimigo não ataque o player nesse caso
		
	elif enemy.can_hit: # Não está morrendo, mas está levando dano
		animation.play('hit') # Animação de dano vai rodar
		enemy.can_attack = false # Durante o dano não vai ser possível atacar
		hit_sound.play() # Tocar o áudio de hit
		attack_area_collision.set_deferred('disabled', true)
		
	elif enemy.can_attack: # Aqui o inimigo vai estar atacando
		animation.play('attack_anticipation')
		enemy.set_physics_process(false)
		
func _on_animation_finished(anim_name: String) -> void: # A função para lidar com o final de uma animação
	match anim_name:
		'hit':
			enemy.can_hit = false # O inimigo não vai continuar levando dano depois de acabar a animação de hit
			enemy.set_physics_process(true) # Acabou o hit, o inimigo pode voltar a se mexer
			enemy.can_attack = false
			
		'dead':
			enemy.kill_enemy() # É o método para eliminar o inimigo do mapa, após sua morte
			enemy.can_attack = false
		
		'kill':
			enemy.queue_free() # Aqui é excluído o objeto do inimigo do cenário, após sua morte
			
		'attack_left':
			enemy.can_attack = false # O inimigo já acabou o ataque 
			enemy.set_physics_process(true)
		
		'attack_right':
			enemy.can_attack = false # O inimigo já acabou o ataque 
			enemy.set_physics_process(true)
			
		'attack_anticipation':
			animation.play('attack' + enemy.attack_animation_suffix)
