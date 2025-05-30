extends VBoxContainer


@onready var points_label: Label = %PointsLabel
@onready var gain_label: Label = %GainLabel
@onready var multiplicator_label: Label = %MultiplicatorLabel
@onready var upgrade_list: VBoxContainer = %UpgradeList
@onready var timer: Timer = $"../../../Timer"

var pts_text: String = "%s pts"
var multiplier_text: String = "Multiplier x%s"
var pts_per_sec_text: String = "%s pts / sec"

var pts: int
var pts_per_click: int = 1
var pts_per_seconds: int
var multiplier: int = 1
var upgrades_owned: Dictionary

func _ready() -> void:
	_load()
	timer.timeout.connect(_add_pts_per_sec)
	
	
func _process(_delta: float) -> void:
	points_label.text = pts_text % pts
	multiplicator_label.text = multiplier_text % multiplier
	gain_label.text = pts_per_sec_text % pts_per_seconds
	
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save()


func _save() -> void:
	var data: SaveManager = SaveManager.new()
	
	data.points = pts
	data.pts_per_seconds = int(gain_label.text)
	data.pts_per_clicks = pts_per_click
	data.multiplier = multiplier
	data.upgrades_owned = upgrades_owned
	
	ResourceSaver.save(data, SaveManager.SAVE_PATH)


func _load() -> void:
	if ResourceLoader.exists(SaveManager.SAVE_PATH):
		var data = ResourceLoader.load(SaveManager.SAVE_PATH) as SaveManager
		
		pts = data.points
		gain_label.text = str(data.pts_per_seconds) + " pts / sec"
		pts_per_click = data.pts_per_clicks
		pts_per_seconds = data.pts_per_seconds
		multiplier = data.multiplier
		upgrades_owned = data.upgrades_owned


func _on_cookie_pressed() -> void:
	pts += pts_per_click * multiplier


func _on_upgrade_list_card_purchased(card: UpgradeCard) -> void:
	var price = int(card.upgrade_price.text)
	
	if pts >= price:
		if card.upgrade_name.text == "Rebirth":
			multiplier += 1
			pts_per_click = 1
			pts_per_seconds = 0
			pts = 1
			
			for upgrade: UpgradeCard in get_tree().get_nodes_in_group("card"):
				upgrades_owned[upgrade.upgrade_name.text] = 0
				
		upgrades_owned[card.upgrade_name.text] += 1
		card.upgrade_owned.text = str(upgrades_owned[card.upgrade_name.text])
		
		pts_per_click += card.pts_per_click
		pts_per_seconds += card.pts_per_seconds
			
		pts -= price
	else:
		print("Not enough Points.")


func _on_upgrade_list_update_card(card: UpgradeCard) -> void:
	if not upgrades_owned.has(card.upgrade_name.text):
		upgrades_owned[card.upgrade_name.text] = 0
	
	card.upgrade_owned.text = str(upgrades_owned[card.upgrade_name.text])


func _add_pts_per_sec():
	pts += pts_per_seconds
