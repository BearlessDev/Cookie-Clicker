extends VBoxContainer


signal card_purchased(card: UpgradeCard)

var upgrades: Array[Dictionary] = [
	{
		"name": "Upgrade 1",
		"description": "+1 pts / click",
		"price": 50,
		"owned": 0,
		"pts_per_sec": 0,
		"pts_per_click": 1
	},
	{
		"name": "Upgrade 2",
		"description": "+2 pts / sec",
		"price": 120,
		"owned": 0,
		"pts_per_sec": 2,
		"pts_per_click": 0
	}
]

var upgrade_card


func _ready():
	_create_upgrade_cards()
	

func _create_upgrade_cards():
	for upgrade in upgrades:
		upgrade_card = preload("res://scenes/upgrade_card.tscn").instantiate() as UpgradeCard

		upgrade_card.upgrade_name.text = upgrade.name
		upgrade_card.upgrade_description.text = upgrade.description
		upgrade_card.upgrade_price.text = str(upgrade.price) + " pts"
		upgrade_card.upgrade_owned.text = str(upgrade.owned)
		
		upgrade_card.pressed.connect(_on_card_click.bind(upgrade_card))
		
		add_child(upgrade_card)


func _on_card_click(card: UpgradeCard):
	card_purchased.emit(card)
