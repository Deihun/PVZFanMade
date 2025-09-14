extends Node2D

func _ready() -> void:
	$main_camera.play_camera()
	$main_camera.when_starting_callable.append(Callable($sun_falling_behaviour,"start"))
