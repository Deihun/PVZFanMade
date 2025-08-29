extends Node2D

var tutorial_starts :=false
var selecting_plant_tutorial_complete := false 
var collect_sun_tutorial:=false
var another_peashooter_tutorial := false
var sun_value_mark :=0

var sun_production_start:=false

func _ready() -> void:
	QuickDataManagement.change_sun_value(150)
	$main_camera.play_camera()
	#$main_camera.when_starting_callable.append(Callable($sun_falling_behaviour,"start"))
	await get_tree().create_timer(9.0).timeout
	$Day/SingleGrassGrow._trigger_start()
	tutorial_starts =true

func _process(delta: float) -> void:
	if !tutorial_starts: return
	if !selecting_plant_tutorial_complete:
		select_a_plant()
		return
	if !collect_sun_tutorial:
		collect_sun()
		return
	if !another_peashooter_tutorial:
		plant_another_peashooter()
		return

func select_a_plant():
	$Day/TutorialPart11.show()
	if QuickDataManagement._selected_data_in_seed_packet: $Day/TutorialPart12.show()
	if QuickDataManagement.global_calls_manager._plant_exist_in_game.size() >= 1:
		selecting_plant_tutorial_complete =true
		$Day/TutorialPart11.hide()
		$Day/TutorialPart12.hide()
		sun_value_mark = QuickDataManagement.sun
		#$Day/TutorialPart13.show()
		#await get_tree().create_timer(3.0).timeout
		#$Day/TutorialPart13.hide()
		#await get_tree().create_timer(3.0).timeout
		#$zombie_wave_management._play()

func collect_sun():
	start_sun_production()
	$Day/TutorialPart13.show()
	if QuickDataManagement.sun >= (sun_value_mark+50):
		collect_sun_tutorial=true
		$Day/TutorialPart13.hide()
		
		#await get_tree().create_timer(3.0).timeout
		#$Day/TutorialPart14.hide()
		#await get_tree().create_timer(3.0).timeout
		#$zombie_wave_management._play()

func plant_another_peashooter():
	$Day/TutorialPart14.show()
	if QuickDataManagement.global_calls_manager._plant_exist_in_game.size() >= 2:
		another_peashooter_tutorial=true
		$Day/TutorialPart14.hide()
		$zombie_wave_management._play()
		set_process(false)

func start_sun_production():
	if sun_production_start:return
	$sun_falling_behaviour.start()
	sun_production_start=true
