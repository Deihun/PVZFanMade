extends Node2D



func _ready() -> void:
	set_process(false)
	$lane_1.tile_column_2.place_plant_without_cost(load("res://unit/plant/peashooter/Peashooter_script.tscn").instantiate())
	$lane_1.tile_column_4.place_plant_without_cost(load("res://unit/plant/peashooter/Peashooter_script.tscn").instantiate())
	$main_camera.get_node("HUD_normal_selection").hide_shovel=true
	await get_tree().create_timer(1.0).timeout
	$main_camera/Bubble.show()
	await get_tree().create_timer(4.0).timeout
	$main_camera/Bubble/text.text = "But things is about to\n get CRAZYYYY!!!"
	await get_tree().create_timer(4.0).timeout
	$main_camera/Shovel.show()
	$main_camera/Bubble/text.text = "Use the shovel to clear the lawn"
	set_process(true)

	
	
	


func _process(delta: float) -> void:
	if QuickDataManagement.global_calls_manager._plant_exist_in_game.size() == 0: when_the_lawn_is_cleared()

func when_the_lawn_is_cleared():
	set_process(false)
	$main_camera/Bubble/text.text = "Have you ever played Bowling before?"
	await get_tree().create_timer(3.0).timeout
	$main_camera/Bubble/text.text = "And add it with a twist?"
	await get_tree().create_timer(3.0).timeout
	$main_camera/Bubble/text.text = "Cause were about to set \nnew record with these zombies!"
	await get_tree().create_timer(3.0).timeout
	$main_camera/Bubble.hide()
	$main_camera/Shovel.hide()
	$main_camera.play_camera()
