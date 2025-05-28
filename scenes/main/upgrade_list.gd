extends VBoxContainer


signal card_purchased(card: Button)

var upgrades: Array[Dictionary] = [
	{
		"name": "Upgrade 1",
		"description": "+2 pts / click",
		"price": 12,
		"owned": 0
	},
	{
		"name": "Upgrade 2",
		"description": "+1 pt / sec",
		"price": 120,
		"owned": 0
	}
]

var card: Button


func _ready():
	_create_upgrade_cards()
	

func _create_upgrade_cards():
	for upgrade in upgrades:
		card = preload("res://scenes/upgrade_card.tscn").instantiate()

		card.upgrade_name.text = upgrade.name
		card.upgrade_description.text = upgrade.description
		card.upgrade_price.text = str(upgrade.price)
		card.upgrade_owned.text = str(upgrade.owned)
		
		card.pressed.connect(_on_card_click.bind(card))
		
		add_child(card)


func _on_card_click(card: Button):
	card_purchased.emit(card)
