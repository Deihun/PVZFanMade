extends Node2D

func play_is_press():
	$AudioStreamPlayer.play()
	var level := 1
	for i in 11:
		if QuickDataManagement.savemanager.level_exist(str("day1-",level)): 
			level += 1
			continue
		else:
			get_tree().change_scene_to_file(str("res://Resource/Levels/Tutorial_Part/level_1_tutorial_day_",level,".tscn"))
			return
		#if QuickDataManagement.savemanager.level_exist(str("day1-",level)):
			#get_tree().change_scene_to_file(str("res://Resource/Levels/Tutorial_Part/level_1_tutorial_day_",level+1,".tscn"))
			#return
	
	
	#QuickDataManagement.savemanager._reset_save()
	get_tree().change_scene_to_file("res://Resource/Levels/Tutorial_Part/level_1_tutorial_day_1.tscn")
func settings_is_press():
	pass
func almanac_is_press():
	pass
func about_is_press():
	pass

func _on_play_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed: play_is_press()
func _on_play_mouse_entered() -> void:
	$VBoxContainer/play/PlayButtonHover.show()
	$VBoxContainer/play/PlayButtonUnhover.hide()
func _on_play_mouse_exited() -> void:
	$VBoxContainer/play/PlayButtonHover.hide()
	$VBoxContainer/play/PlayButtonUnhover.show()

func _on_quit_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed: get_tree().quit()
func _on_quit_mouse_entered() -> void:
	$VBoxContainer/QUIT/PlayButtonHover.show()
	$VBoxContainer/QUIT/PlayButtonUnhover.hide()
func _on_quit_mouse_exited() -> void:
	$VBoxContainer/QUIT/PlayButtonHover.hide()
	$VBoxContainer/QUIT/PlayButtonUnhover.show()

func _on_settings_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed: settings_is_press()
func _on_settings_mouse_entered() -> void:
	$VBoxContainer/SETTINGS/PlayButtonHover.show()
	$VBoxContainer/SETTINGS/PlayButtonUnhover.hide()
func _on_settings_mouse_exited() -> void:
	$VBoxContainer/SETTINGS/PlayButtonHover.hide()
	$VBoxContainer/SETTINGS/PlayButtonUnhover.show()

func _on_almanac_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed: almanac_is_press()
func _on_almanac_mouse_entered() -> void:
	$VBoxContainer/ALMANAC/PlayButtonHover.show()
	$VBoxContainer/ALMANAC/PlayButtonUnhover.hide()
func _on_almanac_mouse_exited() -> void:
	$VBoxContainer/ALMANAC/PlayButtonHover.hide()
	$VBoxContainer/ALMANAC/PlayButtonUnhover.show()

func _on_about_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed: about_is_press()
func _on_about_mouse_entered() -> void:
	$VBoxContainer/ABOUT/PlayButtonHover.show()
	$VBoxContainer/ABOUT/PlayButtonUnhover.hide()
func _on_about_mouse_exited() -> void:
	$VBoxContainer/ABOUT/PlayButtonHover.hide()
	$VBoxContainer/ABOUT/PlayButtonUnhover.show()
