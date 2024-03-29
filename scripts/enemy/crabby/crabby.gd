extends EnemyTemplate # Esse script vai herdar de enemy template
# Herdando de Enemy template é possível modificar os atributos do inimigo

# Criar o nome desse script
class_name Crabby

# Criar a função, que vai ser executada primeiro para armazenar os itens da drop list
# O inimgo não pode espawnar o item depois de ser derrotado, ou seja, depois da animação de kill, deve-se espawnar antes
func _ready() -> void:
	randomize() # Aqui vai ser gerado um número aleatório de 0 a 100, que significa a porcentagem de drop do item
	# O número gerado com o randomize vai ser comparado com a lista de drop e se for igual, esse item é spawnado
	
	# Criando a drop list para esse inimigo 
	drop_list = {
		'Health Potion' : ['res://assets/item/consumable/health_potion.png', 15, 'Health', 5, 2], # O tipo de item é uma chave e está relacionado, com as informações do item
		# A primeira informação sobre o item é seu caminho para imagem, seguido da probabilidade de drop, seguido do tipo do item, seu valor e seu valor de venda
		'Mana POtion' : ['res://assets/item/consumable/mana_potion.png', 8, 'Mana', 5, 5],
		'Crabby Eye' : ['res://assets/item/resource/crabby/crab_eye.png', 35, 'Resource', {}, 3], # Itens do tipo resource não podem ser consumidos, logo não recuperam nada e apenas podem ser vendidos
		'Crabby Pincers' : ['res://assets/item/resource/crabby/crab_pincers.png', 10, 'Resource', {}, 7],
		'Crabby Belt' : ['res://assets/item/equipment/crabby_belt.png', 5, 'Equipment', {'Health': 3, 'Attack': 1}, 30],
		'Crabby Axe': ['res://assets/item/equipment/crabby_axe.png', 2, 'Weapon', { 'Attack': 3, 'Defense': 1}, 40]
		# O item da máscara é do tipo equipável, ou seja, seu valor não vai ser mais vazio, mas sim uma lista com o tipo de atributo melhorado pela sua obtenção e quanto será melhorado
	}

	
