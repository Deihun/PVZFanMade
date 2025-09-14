extends Node2D
func _ready() -> void:
	$main_camera.play_camera()
	$main_camera.when_starting_callable.append(Callable($sun_falling_behaviour,"start"))
	$NewPlantUnlockRewardNode._call_this_when_collecting_reward_ArrayCallable.append(Callable(self,"_unlock_sunflower"))

func _unlock_sunflower()->void :
	QuickDataManagement.savemanager.unlock_tier("wallnut","tier2")
