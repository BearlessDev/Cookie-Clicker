class_name SaveManager extends Resource

const DATA_FOLDER_PATH = "user://data/"
const SAVE_PATH: String = DATA_FOLDER_PATH + "data.tres"

@export var points: int
@export var multiplier: int = 1
@export var pts_per_clicks: int = 1
@export var pts_per_seconds: int
@export var upgrades_owned: Array[Dictionary]
