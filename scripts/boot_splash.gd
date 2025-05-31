extends Control


@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(_change_to_main_scene)


func _change_to_main_scene() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
