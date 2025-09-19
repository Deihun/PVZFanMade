extends Control

func _ready() -> void:
	$NinePatchRect/music_label/music_slider.value = QuickDataManagement.savemanager.get_value("music")
	$NinePatchRect/sound_sfx_label/sound_sfx_slider.value = QuickDataManagement.savemanager.get_value("sfx")
	$NinePatchRect/fps_label/FPS.selected = QuickDataManagement.savemanager.get_value("fps")

func _screenmode_slider_item_selected(index: int) -> void:
	match index:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)



func _on_resolution_slider_item_selected(index: int) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	match index:
		0: DisplayServer.window_set_size(Vector2i(1920, 1080))
		1: DisplayServer.window_set_size(Vector2i(1280, 720))
		2: DisplayServer.window_set_size(Vector2i(640, 480)) 
	print(DisplayServer.window_get_size())



func _on_fps_item_selected(index: int) -> void:
	match index:
		0: Engine.max_fps = 0
		1: Engine.max_fps = 24
		2: Engine.max_fps = 60
		3: Engine.max_fps = 120
	QuickDataManagement.savemanager.set_value("fps",index)


func _on_confirm_button_pressed() -> void:
	queue_free()


func _on_music_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	var linear = value / 100.0
	var db = linear_to_db(linear)
	AudioServer.set_bus_volume_db(bus_index, db)


func _on_sound_sfx_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("SFX")
	var linear = value / 100.0
	var db = linear_to_db(linear)
	AudioServer.set_bus_volume_db(bus_index, db)


func _on_tree_exited() -> void:
	QuickDataManagement.savemanager.set_value("music",$NinePatchRect/music_label/music_slider.value)
	QuickDataManagement.savemanager.set_value("sfx",$NinePatchRect/sound_sfx_label/sound_sfx_slider.value)
