extends Control

var UPGRADES: Array[Dictionary] = [
	{
		"name": "Butterfinger",
		"description": "+1 pts / click",
		"price": 150,
		"owned": 0,
		"pts_per_click": 1,
		"pts_per_sec": 0
	},
	{
		"name": "Grandma",
		"description": "+2 pts / sec",
		"price": 300,
		"owned": 0,
		"pts_per_click": 0,
		"pts_per_sec": 2
	},
	{
		"name": "Chocolate Chips",
		"description": "+5 pts / click",
		"price": 800,
		"owned": 0,
		"pts_per_click": 5,
		"pts_per_sec": 0
	},
	{
		"name": "Cookie Oven",
		"description": "+10 pts / sec",
		"price": 2_000,
		"owned": 0,
		"pts_per_click": 0,
		"pts_per_sec": 10
	},
	{
		"name": "Golden Topping",
		"description": "+15 pts / click",
		"price": 6_500,
		"owned": 0,
		"pts_per_click": 15,
		"pts_per_sec": 0
	},
	{
		"name": "Cookie Factory",
		"description": "+50 pts / sec",
		"price": 18_000,
		"owned": 0,
		"pts_per_click": 0,
		"pts_per_sec": 50
	},
	{
		"name": "Cookie Hammer",
		"description": "+60 pts / click",
		"price": 60_000,
		"owned": 0,
		"pts_per_click": 60,
		"pts_per_sec": 0
	},
	{
		"name": "Automated Farm",
		"description": "+200 pts / sec",
		"price": 200_000,
		"owned": 0,
		"pts_per_click": 0,
		"pts_per_sec": 200
	},
	{
		"name": "Godfinger",
		"description": "+250 pts / click",
		"price": 800_000,
		"owned": 0,
		"pts_per_click": 250,
		"pts_per_sec": 0
	},
	{
		"name": "Time Machine",
		"description": "+1000 pts / sec",
		"price": 3_500_000,
		"owned": 0,
		"pts_per_click": 0,
		"pts_per_sec": 1000
	},
	{
		"name": "Infinity Glove",
		"description": "+1200 pts / click",
		"price": 15_000_000,
		"owned": 0,
		"pts_per_click": 1200,
		"pts_per_sec": 0
	},
	{
		"name": "Portal",
		"description": "+5000 pts / sec",
		"price": 60_000_000,
		"owned": 0,
		"pts_per_click": 0,
		"pts_per_sec": 5000
	},
	{
		"name": "Divine Touch",
		"description": "+7000 pts / click",
		"price": 250_000_000,
		"owned": 0,
		"pts_per_click": 7000,
		"pts_per_sec": 0
	},
	{
		"name": "Cookie Planet",
		"description": "+25000 pts / sec",
		"price": 1_000_000_000,
		"owned": 0,
		"pts_per_click": 0,
		"pts_per_sec": 25000
	},
	{
		"name": "Baker God Mode",
		"description": "+50000 pts / click",
		"price": 5_000_000_000,
		"owned": 0,
		"pts_per_click": 50000,
		"pts_per_sec": 0
	},
	{
		"name": "Cookie Multiverse",
		"description": "+150000 pts / sec",
		"price": 25_000_000_000,
		"owned": 0,
		"pts_per_click": 0,
		"pts_per_sec": 150000
	},
	{
		"name": "Rebirth",
		"description": "+1 Multiplier",
		"price": 100_000_000_000,
		"owned": 0,
		"pts_per_click": 0,
		"pts_per_sec": 0
	}
]

# References
@onready var points_label: Label = %PointsLabel
@onready var gain_label: Label = %GainLabel
@onready var multiplicator_label: Label = %MultiplicatorLabel
@onready var pts_per_sec_timer: Timer = $PtsPerSecTimer
@onready var upgrade_list: VBoxContainer = %UpgradeList
@onready var cookie: Button = %Cookie

# Variables
var points: int
var multiplier: int = 1
var pts_per_click: int = 1
var pts_per_sec: int
var owned_upgrades: Dictionary
var is_fullscreen: bool

var points_text = "%s pts"
var pts_per_sec_text = "%s pts / sec"
var multiplicator_text = "Multiplier x%s"


# Functions
func _ready() -> void:
	get_window().title = "Cookie Clicker - v" + ProjectSettings.get_setting("application/config/version")
	_load()
	_create_upgrade_cards()
	
	pts_per_sec_timer.timeout.connect(_add_points_per_sec)


func _process(_delta: float) -> void:
	points_label.text = points_text % format_number(points)
	gain_label.text = pts_per_sec_text % format_number(pts_per_sec)
	multiplicator_label.text = multiplicator_text % multiplier
	
	for card: UpgradeCard in get_tree().get_nodes_in_group("card"):
		card.upgrade_owned.text = format_number(owned_upgrades[card.upgrade_name.text])
	
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save()
		
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		if not DisplayServer.window_get_mode() == Window.MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			is_fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			is_fullscreen = false


func _create_upgrade_cards() -> void:
	for i in range(UPGRADES.size()):
		var upgrade_card: UpgradeCard = preload("res://scenes/upgrade_card.tscn").instantiate()
		
		if UPGRADES[i]["name"] == "Rebirth":
			upgrade_card.upgrade_name.text = UPGRADES[i]["name"]
			upgrade_card.upgrade_description.text = UPGRADES[i]["description"]
			upgrade_card.upgrade_price.text = format_number(UPGRADES[i]["price"]) + " pts"
			upgrade_card.upgrade_owned.visible = false
		
		upgrade_card.upgrade_name.text = UPGRADES[i]["name"]
		upgrade_card.upgrade_description.text = UPGRADES[i]["description"]
		upgrade_card.upgrade_price.text = format_number(UPGRADES[i]["price"]) + " pts"
		upgrade_card.upgrade_owned.text = str(UPGRADES[i]["owned"])
		upgrade_card.pts_per_click = UPGRADES[i]["pts_per_click"]
		upgrade_card.pts_per_seconds = UPGRADES[i]["pts_per_sec"]
		
		upgrade_card.add_to_group("card")
		
		upgrade_card.pressed.connect(_on_card_purshased.bind(upgrade_card, i))
		
		upgrade_list.add_child(upgrade_card)
		
		if not owned_upgrades.has(upgrade_card.upgrade_name.text):
			owned_upgrades[upgrade_card.upgrade_name.text] = 0


func _add_points_on_click() -> void:
	points += pts_per_click * multiplier


func _add_points_per_sec() -> void:
	points += pts_per_sec

	
func _on_card_purshased(card: UpgradeCard, i: int) -> void:
	var price: int = UPGRADES[i]["price"]
	
	if points >= price:
		points -= price
		
		pts_per_click += card.pts_per_click
		pts_per_sec += card.pts_per_seconds
		
		if card.upgrade_name.text == "Rebirth":
			points = 0
			pts_per_click = 1
			pts_per_sec = 0
			multiplier += 1
			
			for upgrade: UpgradeCard in get_tree().get_nodes_in_group("card"):
				owned_upgrades[upgrade.upgrade_name.text] = 0
		
		owned_upgrades[card.upgrade_name.text] += 1
		


# Format the Number ex. 10_000 = 10k and 10_000_000 = 10M
func format_number(n: int) -> String:
	if n >= 1_000_000_000_000:
		var i: float = snapped(float(n)/1_000_000_000_000, .01)
		return str(i).replace(",", ".") + "T"
	elif n >= 1_000_000_000:
		var i: float = snapped(float(n)/1_000_000_000, .01)
		return str(i).replace(",", ".") + "Md"
	elif n >= 1_000_000:
		var i: float = snapped(float(n)/1_000_000, .01)
		return str(i).replace(",", ".") + "M"
	elif n >= 1_000:
		var i: float = snapped(float(n)/1_000, .01)
		return str(i).replace(",", ".") + "k"
	else:
		return str(n)


# Data Saving/Loading
func _save() -> void:
	var data: SaveManager = SaveManager.new()
	
	data.points = points
	data.multiplier = multiplier
	data.pts_per_click = pts_per_click
	data.pts_per_sec = pts_per_sec
	data.owned_upgrades = owned_upgrades
	data.is_fullscreen = is_fullscreen
	
	ResourceSaver.save(data, SaveManager.SAVE_PATH)


func _load() -> void:
	if ResourceLoader.exists(SaveManager.SAVE_PATH):
		var data = ResourceLoader.load(SaveManager.SAVE_PATH) as SaveManager
		
		points = data.points
		multiplier = data.multiplier
		pts_per_click = data.pts_per_click
		pts_per_sec = data.pts_per_sec
		owned_upgrades = data.owned_upgrades
		is_fullscreen = data.is_fullscreen
