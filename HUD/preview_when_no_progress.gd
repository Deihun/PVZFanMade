extends Node2D
 #preload().instantiate()
func _ready() -> void:
	quick_demo_affecting_saveManager()
	place_all_plants()
	QuickDataManagement.sound_manager.play_music(load("res://Resource/Levels/Tutorial_Part/Ultimate Battle - Modern Day - Plants vs. Zombies 2.mp3"))
	QuickDataManagement.evolution_power_point = 10
	var sfx_bus := AudioServer.get_bus_index("SFX")
	var original_volume := AudioServer.get_bus_volume_db(sfx_bus)
	AudioServer.set_bus_volume_db(sfx_bus, -80) # mute
	await get_tree().create_timer(5.0).timeout # delay (2 seconds)
	AudioServer.set_bus_volume_db(sfx_bus, original_volume) # restore



func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://Resource/Levels/Tutorial_Part/level_1_tutorial_day_1.tscn")

func  quick_demo_affecting_saveManager()-> void:
	QuickDataManagement.savemanager.unlock_new_plant("peashooter")
	QuickDataManagement.savemanager.unlock_new_plant("sunflower")
	QuickDataManagement.savemanager.unlock_new_plant("potatomine")
	QuickDataManagement.savemanager.unlock_new_plant("wallnut")
	QuickDataManagement.savemanager.unlock_new_tools("powerbank")
	QuickDataManagement.savemanager.unlock_tier("peashooter","tier1")
	QuickDataManagement.savemanager.unlock_tier("peashooter","tier2")
	QuickDataManagement.savemanager.unlock_tier("peashooter","tier3")
	QuickDataManagement.savemanager.unlock_tier("sunflower","tier1")
	QuickDataManagement.savemanager.unlock_tier("sunflower","tier2")
	QuickDataManagement.savemanager.unlock_tier("sunflower","tier3")
	QuickDataManagement.savemanager.unlock_tier("wallnut","tier1")
	QuickDataManagement.savemanager.unlock_tier("wallnut","tier2")
	QuickDataManagement.savemanager.unlock_tier("wallnut","tier3")
	QuickDataManagement.savemanager.unlock_tier("potatomine","tier1")
	QuickDataManagement.savemanager.unlock_tier("potatomine","tier2")
	QuickDataManagement.savemanager.unlock_tier("potatomine","tier3")
	await get_tree().create_timer(10.0).timeout
	QuickDataManagement.savemanager._reset_save()

func place_all_plants()-> void:
	await get_tree().create_timer(1.0).timeout
	$lane_1.tile_column_1.place_plant_without_cost(preload("res://unit/plant/Sunflower/sunflower.tscn").instantiate())
	$lane_1.tile_column_2.place_plant_without_cost(preload("res://unit/plant/peashooter/Peashooter_script.tscn").instantiate())
	$lane_1.tile_column_3.place_plant_without_cost(preload("res://unit/plant/peashooter/Peashooter_script.tscn").instantiate())
	$lane_2.tile_column_1.place_plant_without_cost(preload("res://unit/plant/Sunflower/sunflower.tscn").instantiate())
	$lane_2.tile_column_1._on_tier_a_option_mouse_entered()
	$lane_2.tile_column_1.power_occupied_tile()
	$lane_2.tile_column_1.on_release_perform_selected_action()
	$lane_2.tile_column_1.power_occupied_tile()
	$lane_2.tile_column_1._on_tier_a_option_mouse_entered()
	$lane_2.tile_column_1.on_release_perform_selected_action()
	$lane_2.tile_column_2.place_plant_without_cost(preload("res://unit/plant/Sunflower/sunflower.tscn").instantiate())
	$lane_2.tile_column_3.place_plant_without_cost(preload("res://unit/plant/peashooter/Peashooter_script.tscn").instantiate())
	$lane_2.tile_column_7.place_plant_without_cost(preload("res://unit/plant/Potatomine/potatomine_script.tscn").instantiate())
	$lane_2.tile_column_8.place_plant_without_cost(preload("res://unit/plant/Wallnut/wallnut.tscn").instantiate())
	
	$lane_3.tile_column_1.place_plant_without_cost(preload("res://unit/plant/peashooter/Peashooter_script.tscn").instantiate())
	$lane_3.tile_column_1._on_tier_a_option_mouse_entered()
	$lane_3.tile_column_1.power_occupied_tile()
	$lane_3.tile_column_1.on_release_perform_selected_action()
	$lane_3.tile_column_1._on_tier_a_option_mouse_entered()
	$lane_3.tile_column_1.power_occupied_tile()
	$lane_3.tile_column_1.on_release_perform_selected_action()
	$lane_3.tile_column_1._on_tier_b_option_mouse_entered()
	$lane_3.tile_column_1.power_occupied_tile()
	$lane_3.tile_column_1.on_release_perform_selected_action()
	
	$lane_3.tile_column_2.place_plant_without_cost(preload("res://unit/plant/Sunflower/sunflower.tscn").instantiate())
	$lane_3.tile_column_3.place_plant_without_cost(preload("res://unit/plant/Sunflower/sunflower.tscn").instantiate())
	$lane_3.tile_column_5.place_plant_without_cost(preload("res://unit/plant/Wallnut/wallnut.tscn").instantiate())
	
	$lane_4.tile_column_1.place_plant_without_cost(preload("res://unit/plant/Potatomine/potatomine_script.tscn").instantiate())
	$lane_4.tile_column_1._on_tier_b_option_mouse_entered()
	$lane_4.tile_column_1.power_occupied_tile()
	$lane_4.tile_column_1.on_release_perform_selected_action()
	$lane_4.tile_column_1._on_tier_a_option_mouse_entered()
	$lane_4.tile_column_1.power_occupied_tile()
	$lane_4.tile_column_1.on_release_perform_selected_action()
	$lane_4.tile_column_1._on_tier_b_option_mouse_entered()
	$lane_4.tile_column_1.power_occupied_tile()
	$lane_4.tile_column_1.on_release_perform_selected_action()
	
	$lane_4.tile_column_2.place_plant_without_cost(preload("res://unit/plant/peashooter/Peashooter_script.tscn").instantiate())
	$lane_4.tile_column_2._on_tier_b_option_mouse_entered()
	$lane_4.tile_column_2.power_occupied_tile()
	$lane_4.tile_column_2.on_release_perform_selected_action()
	$lane_4.tile_column_2._on_tier_a_option_mouse_entered()
	$lane_4.tile_column_2.power_occupied_tile()
	$lane_4.tile_column_2.on_release_perform_selected_action()
	$lane_4.tile_column_2._on_tier_a_option_mouse_entered()
	$lane_4.tile_column_2.power_occupied_tile()
	$lane_4.tile_column_2.on_release_perform_selected_action()
	
	$lane_4.tile_column_3.place_plant_without_cost(preload("res://unit/plant/peashooter/Peashooter_script.tscn").instantiate())
	$lane_4.tile_column_4.place_plant_without_cost(preload("res://unit/plant/Wallnut/wallnut.tscn").instantiate())
	
	$lane_5.tile_column_1.place_plant_without_cost(preload("res://unit/plant/Sunflower/sunflower.tscn").instantiate())
	$lane_5.tile_column_2.place_plant_without_cost(preload("res://unit/plant/peashooter/Peashooter_script.tscn").instantiate())
	$lane_5.tile_column_4.place_plant_without_cost(preload("res://unit/plant/peashooter/Peashooter_script.tscn").instantiate())
	$lane_5.tile_column_5.place_plant_without_cost(preload("res://unit/plant/Sunflower/sunflower.tscn").instantiate())
	$lane_5.tile_column_5._on_tier_a_option_mouse_entered()
	$lane_5.tile_column_5.power_occupied_tile()
	$lane_5.tile_column_5.on_release_perform_selected_action()
	$lane_5.tile_column_5._on_tier_b_option_mouse_entered()
	$lane_5.tile_column_5.power_occupied_tile()
	$lane_5.tile_column_5.on_release_perform_selected_action()
	$lane_5.tile_column_6.place_plant_without_cost(preload("res://unit/plant/Wallnut/wallnut.tscn").instantiate())
	$lane_5.tile_column_6.power_occupied_tile()
	$lane_5.tile_column_6._on_tier_a_option_mouse_entered()
	$lane_5.tile_column_6.on_release_perform_selected_action()
	$lane_5.tile_column_6.power_occupied_tile()
	$lane_5.tile_column_6._on_tier_a_option_mouse_entered()
	$lane_5.tile_column_6.on_release_perform_selected_action()
	
	await get_tree().create_timer(9.5).timeout
	$lane_3.tile_column_4.place_plant_without_cost(preload("res://unit/plant/CherryBomb/CherryBomb.tscn").instantiate())
	#$lane_4.tile_column_4.place_plant_without_cost()
	#$lane_4.tile_column_6.place_plant_without_cost()
	#$lane_5.tile_column_1.place_plant_without_cost()
	#$lane_5.tile_column_2.place_plant_without_cost()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	QuickDataManagement.common_called_method.enter_new_scene("res://Resource/Levels/Tutorial_Part/level_1_tutorial_day_1.tscn")
