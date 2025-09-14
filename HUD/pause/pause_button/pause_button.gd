extends Node2D

func pause_trigger():
	print("triggering")
	var pause =  load("res://HUD/pause/pause_menu/pause_menu.tscn").instantiate()
	get_parent().add_child(pause)
	pause.position += Vector2(-960,-540)


func _on_interactable_mouse_entered() -> void:
	$PauseHover.show()
	$PauseUnhover.hide()
func _on_interactable_mouse_exited() -> void:
	$PauseHover.hide()
	$PauseUnhover.show()
func _on_interactable_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed: pause_trigger()
