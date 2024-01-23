extends Sprite

# Dar o nome pro objeto 
class_name EnemyTexture

# Criar 3 variáveis para acessar o enemy template, a área de ataque e a animatiom
export(NodePath) onready var enemy = get_node(enemy) as KinematicBody2D
export(NodePath) onready var attack_area_collision = get_node(attack_area_collision) as CollisionShape2D
export(NodePath) onready var animation = get_node(animation) as AnimationPlayer

# Criar a função de animação para receber a velocity do inimigo e aplicar na animação de correr
func animate(_velocity: Vector2) -> void:
	pass


func _on_animation_finished(_anim_name: String) -> void:
	pass # Replace with function body.
