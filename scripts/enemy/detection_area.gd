extends Area2D

# Primeira a fazer é dar um nome para esse script
class_name DetectionArea

# Guardar referência ao EnemyTEmplate
export(NodePath) onready var enemy = get_node(enemy) as KinematicBody2D

func on_body_entered(body: Player) -> void: # Função para verificar quando o corpo do jogador entrou na área
	enemy.player_ref = body # Player ref vai ser uma variável de enemy template, que vai guardar referência ao player como body, ou seja, como um corpo

func on_body_exited(_body: Player) -> void: # Função para verificar quando o personagem saiu da área de detecção
	# Esse _body serve para dizer, que não precisa-se do body, pois assim que o player sair da área de detecção a referência ao player vai ser perdida
	enemy.player_ref = null # Não tem mais referência ao player
