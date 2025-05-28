extends VBoxContainer


@onready var points_label: Label = %PointsLabel
@onready var gain_label: Label = %GainLabel
@onready var multiplicator_label: Label = %MultiplicatorLabel

var pts_text: String = "%s pts"
var multiplier_text: String = "Multiplier x%s"

var pts: int
var pts_per_click: int = 1
var multiplier: int = 1
var upgrades_owned: Array[Dictionary]

func _ready() -> void:
	_load()
	
	
func _process(_delta: float) -> void:
	points_label.text = pts_text % pts
	multiplicator_label.text = multiplier_text % multiplier
	
	
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
		multiplier = data.multiplier
		upgrades_owned = data.upgrades_owned


func _on_cookie_pressed() -> void:
	pts += pts_per_click * multiplier


func _on_upgrade_list_card_purchased(card: UpgradeCard) -> void:
	var price = int(card.upgrade_price.text)
	var owned = int(card.upgrade_owned.text)
	
	if pts >= price:
		owned += 1
		print(owned)
		pts -= price
	else:
		print("Not enough Points.")
