extends Area2D

# Nomeie esse script
class_name FireSpell

# Variável para o dano do feitiço
var spell_damage : int

# Criar a função para executar, assim que o objeto for instanciado
func _ready() -> void:
	for children in get_children(): # Obter todos os filhos do objeto raiz
		if children is Particles2D:
			 # Verificar se o tipo do filho é de partículas 2D
			# Sempre que o filho for uma partícula, deve-se mudar o emitting para true
			children.emitting = true


func on_animation_finished(_anim_name: String): # Função que lida com o fim de animações
	# Terminou a animação, então delete o feitiço da cena
	queue_free()
