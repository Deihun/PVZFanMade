extends Node2D

func _ready() -> void:
	$main_camera.play_camera()
	$main_camera.when_starting_callable.append(Callable($sun_falling_behaviour,"start"))
	#$NewPlantUnlockRewardNode._call_this_when_collecting_reward_ArrayCallable.append(Callable(self,"_open_link_to_survey"))
	#
#
#func _open_link_to_survey()-> void:
	#OS.shell_open("https://example.com")
