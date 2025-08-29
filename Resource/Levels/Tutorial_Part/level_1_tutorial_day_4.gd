extends Node2D

func _ready() -> void:
	$lane_3.tile_column_3.place_plant_without_cost(load("res://unit/plant/Potatomine/potatomine_script.tscn").instantiate())

	$main_camera.play_camera()
	$main_camera.when_starting_callable.append(Callable($sun_falling_behaviour,"start"))
