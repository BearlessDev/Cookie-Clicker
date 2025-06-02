extends Control


@onready var timer: Timer = $Timer

var is_fullscreen: bool


func _ready() -> void:
	_load()
	
	timer.timeout.connect(_change_to_main_scene)
	
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _change_to_main_scene() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _load() -> void:
	if ResourceLoader.exists(SaveManager.SAVE_PATH):
		var data = ResourceLoader.load(SaveManager.SAVE_PATH) as SaveManager
		
		is_fullscreen = data.is_fullscreen
