extends TextureRect


func _on_mouse_entered() -> void:
	$AnimationPlayer.play("Hover")


func _on_mouse_exited() -> void:
	$AnimationPlayer.play("HoverReversed")

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			$AnimationPlayer.play("Click")
