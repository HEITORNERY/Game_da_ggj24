extends Label

# Definir o nome do script
class_name FloatText

# Guardar referência ao objeto Tween
onready var tween : Tween = get_node("Tween")

# Vai precisar de um valor e uma massa
var value : int 
var mass : int = 20

# Vai precisar de uma velocidade e uma gravidade
# A gravidade vai começar apontando para cima, pois o impulso inicial é para cima
# Com o tempo a gravidade vai ficar maior que o impulso e vai descer a popup
var velocity : Vector2
var gravity : Vector2 = Vector2.UP

# Variável pro tipo, que por padrão começa vazia
var type : String = ''
# Tipo é para saber a cor do texto

var type_sign : String = ''
# varia de +, pro caso de estar recuperando algum atributo e para -, caso esteja perdendo algum atributo

# 4 variáveis para as cores da cura da mana e da vida, uma cor para o exp ganho e uma cor pro dano
export(Color) var mana_color
export(Color) var heal_color
export(Color) var exp_color
export(Color) var damage_color

# Crie a função ready para carregar os métodos, que devem começar assim que a cena carregar
func _ready() -> void:
	randomize() # Estaremos trabalhando com valores aleatórios
	velocity = Vector2(rand_range(-10, 10), -30) # A velocidade vai ter esses valores no começo
	# Essa velocidade de -30 é o impulso para cima
	
	floating_text() # Função com o texto que vai ser exibido
	
func floating_text() -> void:
	text = type_sign + str(value) # Passando o valor seguido do sinal para a popup
	
	match type: # Cada caso de type é referente ao efeito de ganho ou perda de atributo e cada type tem sua cor
		'Exp':
			modulate = exp_color
		'Heal':
			modulate = heal_color
		'Mana':
			modulate = mana_color
		'Damage':
			modulate = damage_color
			
	interpolate() # Função que vai interpolar as propriedades da label usando tween
	
func interpolate() -> void:
	var _interpolate_modulate : bool = tween.interpolate_property(self, 'modulate.a', 1.0, 0.0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.7)
	# O objeto que vai ser modificado é a própria label, a propriedade vai ser o modulate alpha, vai começar em 1, que é visível e vai par 0, que é invisível, vai ter um tempo de 0.3s
	# O tipo de transformação é linear e vai ter um delay de 0.7s para dar tempo de criar o objeto e depois chamar a animação
	# O EASE OUT começa a animação rapidamente e termina mais lento
	
	var _interpolate_scale_up : bool = tween.interpolate_property(self, 'rect_scale', Vector2(0,0), Vector2(1.0, 1.0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	# Aqui a propriedade de label é a scale, onde começa com 0, que é não ter o objeto e aumenta para 1, que é o valor para objetos serem gerados e não tem delay, pois vai ser a primeira aser executada
	
	# Aqui vai sumir com a scale do popup
	var _interpolate_scale_down : bool = tween.interpolate_property(self, 'rect_scale', Vector2(1.0, 1.0), Vector2(0.4, 0.4), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.6)
	
	# O delay cria uma ordem, assim o método com menor delay inicia e o de maior finaliza a animação
	
	# Inicie o tween
	var _start : bool = tween.start()
	
	# Garantir que o código acima seja executado completamente antes de prosseguir
	yield(tween, "tween_all_completed")
	queue_free() # Terminou a animação, então deleta o objeto
	
	# Para tirar warnings atribua variáveis com _ no começo para cada método de interpolar de tween
	
func _process(delta) -> void:
	# Lidar com a gravidade 
	velocity += gravity * mass * delta
	rect_position += velocity * delta # Aplicar a gravidade para a posição da popup
		
		
