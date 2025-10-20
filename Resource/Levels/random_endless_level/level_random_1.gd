extends Node2D

func _ready() -> void:
	$main_camera.play_camera()
	$main_camera.when_starting_callable.append(Callable($sun_falling_behaviour,"start"))
	$NewPlantUnlockRewardNode._alternate_call_when_switching_level = Callable(self,"win_level_alternate")

func win_level_alternate()-> void:
	var level_stored_path : Array[String] = [
		"res://Resource/Levels/random_endless_level/level_random_1.tscn",
		"res://Resource/Levels/random_endless_level/level_random_2.tscn",
		"res://Resource/Levels/random_endless_level/level_random_3.tscn",
		"res://Resource/Levels/random_endless_level/level_random_4.tscn",
		"res://Resource/Levels/random_endless_level/level_random_5.tscn",
		"res://Resource/Levels/random_endless_level/level_random_6.tscn"
	]
	for level in level_stored_path: 	if level == get_tree().current_scene.scene_file_path: level_stored_path.erase(level)
	QuickDataManagement.common_called_method.enter_new_scene(level_stored_path.pick_random())
