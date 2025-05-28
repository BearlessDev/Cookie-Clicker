extends Node

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(SaveManager.SAVE_PATH):
		DirAccess.make_dir_absolute(SaveManager.SAVE_PATH)
