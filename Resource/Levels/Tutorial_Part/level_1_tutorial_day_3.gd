extends Node2D

func _ready() -> void:
	$lane_3.tile_column_3.place_plant_without_cost(load("res://unit/plant/peashooter/Peashooter_script.tscn").instantiate())
	$lane_3.tile_column_8.place_plant_without_cost(load("res://unit/plant/Wallnut/wallnut.tscn").instantiate())
	$main_camera.play_camera()
	$main_camera.when_starting_callable.append(Callable($sun_falling_behaviour,"start"))
	await get_tree().create_timer(9.0).timeout
	$Day/full_grass._trigger_start()
	
