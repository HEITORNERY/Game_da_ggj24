extends EnemyTemplate # Esse script vai herdar de enemy template
# Herdando de Enemy template é possível modificar os atributos do inimigo

# Criar o nome desse script
class_name Whale

# Criar a função, que vai ser executada primeiro para armazenar os itens da drop list
# O inimgo não pode espawnar o item depois de ser derrotado, ou seja, depois da animação de kill, deve-se espawnar antes
func _ready() -> void:
	randomize() # Aqui vai ser gerado um número aleatório de 0 a 100, que significa a porcentagem de drop do item
	# O número gerado com o randomize vai ser comparado com a lista de drop e se for igual, esse item é spawnado
	
	# Criando a drop list para esse inimigo 
	drop_list = {
		'Health Potion' : ['res://assets/item/consumable/health_potion.png', 20, 'Health', 5, 2], # O tipo de item é uma chave e está relacionado, com as informações do item
		# A primeira informação sobre o item é seu caminho para imagem, seguido da probabilidade de drop, seguido do tipo do item, seu valor e seu valor de venda
		'Mana POtion' : ['res://assets/item/consumable/mana_potion.png', 15, 'Mana', 5, 5],
		'Whale Mouth' : ['res://assets/item/resource/whale/whale_mouth.png', 45, 'Resource', {}, 2], # Itens do tipo resource não podem ser consumidos, logo não recuperam nada e apenas podem ser vendidos
		'Whale Eye' : ['res://assets/item/resource/whale/whale_eye.png', 15, 'Resource', {}, 6],
		'Whale Tail' : ['res://assets/item/resource/whale/whale_tail.png', 3, 'Resource', {}, 25],
		'Whale Mask' : ['res://assets/item/equipment/whale_mask.png', 3, 'Equipment', { 'Mana': 5, 'Magic Attack': 3}, 30]
		# O item da máscara é do tipo equipável, ou seja, seu valor não vai ser mais vazio, mas sim uma lista com o tipo de atributo melhorado pela sua obtenção e quanto será melhorado
	}
	
	
