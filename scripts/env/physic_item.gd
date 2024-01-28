extends RigidBody2D

# Colocar um nome para esse script, que por padrão é o nome do objeto associado
class_name PhysicItem

# Guarde referência a textura
onready var sprite : Sprite = get_node("Texture")

# Vai ter uma referência ao personagem, mas que por padrão vai começar como nulo, pois assim que o item é spawnado o personagem não o conhece ainda
var player_ref : KinematicBody2D = null

# Além disso precisa-se do nome do item, da sua localização na memória e da suas informações
var item_info_list: Array
var item_name : String
var item_texture : StreamTexture

# Criando a função que vai rodar ao começar a cena
func _ready() -> void:
	randomize()
	apply_impulse_randomize() # Gerar um impulso aleatório ao spawnar o item
	
func apply_impulse_randomize() -> void:
	apply_impulse(Vector2.ZERO, Vector2(rand_range(-30, 30), -90)) # Função para gerar impulso
	# vai receber um vector 2 vazio, pois é para começar o impulso de onde morreu o personagem
	# esse impulso vai variar de -30 a 30 em x e -90 em y
	
func update_item_info(key: String, texture: StreamTexture, item_info: Array): # Aqui vai ser criado um método para atualizar as informações do item ao spawnar e vai ser chamado em enemey template, pois todo inimigo vai ter que atualizar as informações do item, depois de spawnar
	yield(self, "ready") # Isso daqui é para garantir que essa função do Physic Item só sejaexecutada, quando o objeto Physic item estiver pronto
	
	# Aqui as variáveis com o nome, as informações do item e sua textura vão estar recebendo os argumentos da função
	item_info_list = item_info
	item_name = key
	item_texture = texture
	
	# A textura da sprite do item vai assumir o valo do argumento texture
	sprite.texture = texture


func on_screen_exited(): # Verificar se o objeto saiu da cena
	queue_free() # Objeto vai ser deletado ao sair da cena
	
	
func on_body_entered(body: Node): # Verificar se um body entrou na área, ou seja, se o corpo do player entrou na área
	if body.inventory.add_item_inventory(sprite.texture):
		queue_free()

# 

	
	
