extends VBoxContainer


signal card_purchased(card: UpgradeCard)
signal update_card(card: UpgradeCard)

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
	},
	{
		"name": "Rebirth",
		"description": "Multiplier +1",
		"price": 1,
		"pts_per_sec": 0,
		"pts_per_click": 0
	}
]

var upgrade_card: UpgradeCard


func _ready():
	_create_upgrade_cards()
	

func _process(_delta: float) -> void:
	for card: UpgradeCard in get_tree().get_nodes_in_group("card"):
		update_card.emit(card)


func _create_upgrade_cards():
	for upgrade in upgrades:
		upgrade_card = preload("res://scenes/upgrade_card.tscn").instantiate()
		
		if upgrade.name == "Rebirth":
			upgrade_card.upgrade_name.text = upgrade.name
			upgrade_card.upgrade_description.text = upgrade.description
			upgrade_card.upgrade_price.text = str(upgrade.price) + " pts"
			upgrade_card.upgrade_owned.visible = false

		upgrade_card.upgrade_name.text = upgrade.name
		upgrade_card.upgrade_description.text = upgrade.description
		upgrade_card.upgrade_price.text = str(upgrade.price) + " pts"
		upgrade_card.pts_per_click = upgrade.pts_per_click
		upgrade_card.pts_per_seconds = upgrade.pts_per_sec
		
		upgrade_card.add_to_group("card")
		
		upgrade_card.pressed.connect(_on_card_click.bind(upgrade_card))
		
		add_child(upgrade_card)


func _on_card_click(card: UpgradeCard):
	card_purchased.emit(card)
