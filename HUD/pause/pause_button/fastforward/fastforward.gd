extends Node2D

var _texture_normal_unhover := preload("res://HUD/pause/pause_button/fastforward/normal_mode_unhover.png")
var _texture_fast_unhover := preload("res://HUD/pause/pause_button/fastforward/fast_mode_unhover.png")
var _texture_ultrafast_unhover := preload("res://HUD/pause/pause_button/fastforward/ultra_fastmode_unhover.png")

var _texture_normal_hover := preload("res://HUD/pause/pause_button/fastforward/normal_mode_hover.png")
var _texture_fast_hover := preload("res://HUD/pause/pause_button/fastforward/fast_mode_hover.png")
var _texture_ultrafast_hover := preload("res://HUD/pause/pause_button/fastforward/ultra_fastmode_hover.png")

func fastforward_trigger():
	match Engine.time_scale:
		1.0:
			Engine.time_scale = 1.5
			$button_unhover.texture = _texture_fast_unhover
			$button_hover.texture =_texture_fast_hover
		1.5:
			Engine.time_scale = 2.5
			$button_unhover.texture = _texture_ultrafast_unhover
			$button_hover.texture =_texture_ultrafast_hover
		2.5:
			Engine.time_scale = 1.0
			$button_unhover.texture = _texture_normal_unhover
			$button_hover.texture =_texture_normal_hover


func _on_interactable_mouse_entered() -> void:
	$button_hover.show()
	$button_unhover.hide()
func _on_interactable_mouse_exited() -> void:
	$button_hover.hide()
	$button_unhover.show()
func _on_interactable_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed: fastforward_trigger()
