extends ParallaxBackground # Tipo herdado, no caso o código é para um ParallaxBackground
class_name background # Aqui cria-se a classe com o mesmo nome do script, pois vai armazenar as informações da paralaxe
export(bool) var can_process # Aqui será criado uma variável do tipo true ou false
#Essa variável vai servir como condição para executar uma ação no jogo
#A condição é de que se o jogador estiver na tela inicial vai ser verdadeiro ese estiver no jogo é falso
export(Array, int) var layer_speed # Aqui será criado uma lista de inteiros
# Nessa lista será aramzenado a velocidade das camadas
func _ready(): # Aqui está a primeira função a ser executada no código, ou seja, ao iniciar a cena
	if can_process == false: # Aqui a condição é de não estar na tela inicial ser igual a false
		set_physics_process(false) # A física de movimento é verificada a cada frame pela physics_process
		# Se não está mais na tela inicial, a física de movimento não irá acontecer
		# Assim a physics não irá identificar nada 
func _physics_process(delta):
	for index in get_child_count(): # Aqui estou criando uma variável index 
		# Essa variável vai receber o valor da função que conta quantos filhos tem o objeto raiz
		if get_child(index) is ParallaxLayer: 
			# Aqui vai acessar um filho de Paralax, com base no valor de index que vai de 0 a 3, pois são 4 filhos
			# E cada filho está sendo verificado seu tipo, que no caso é o de ParallaxLayer
			get_child(index).motion_offset.x -= delta * layer_speed[index]
			# Aqui estamos comparando a posição em x da camada, em relação a origem
			# E está sendo diminuido o valor de x, fazendo com que a camada movimente-se da direita para esquerda
			
		
