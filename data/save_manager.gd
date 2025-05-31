class_name SaveManager extends Resource

const DATA_FOLDER_PATH = "user://data/"
const SAVE_PATH: String = DATA_FOLDER_PATH + "data.tres"

@export var points: int
@export var multiplier: int = 1
@export var pts_per_click: int = 1
@export var pts_per_sec: int
@export var owned_upgrades: Dictionary
@export var is_fullscreen: bool = false
