extends Node


func _ready() -> void:
	DiscordRPC.app_id = 1379056129405095946
	
	DiscordRPC.details = "by Bearless_"
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	DiscordRPC.large_image = "cookie"
	DiscordRPC.large_image_text = "Cookie Clicker"
	
	DiscordRPC.refresh()
