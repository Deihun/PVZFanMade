extends Node2D

func _ready() -> void:
	$main_camera.play_camera()
	$main_camera.when_starting_callable.append(Callable($sun_falling_behaviour,"start"))
	await get_tree().create_timer(9.0).timeout
	$Day/SingleGrassGrow._trigger_start()
	
