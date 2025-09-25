extends Node2D


var pickup_power:= false
var done_tutorial := false
@onready var evolution:= $EvolutionPowerBank

func _process(delta: float) -> void:
	if !pickup_power: pick_up_power_unlocked()
	else:return
	
	

func _ready() -> void:
	print(QuickDataManagement.savemanager._test_get_jsonfile_content())
	set_process(false)
	$lane_3.tile_column_2.place_plant_without_cost(load("res://unit/plant/peashooter/Peashooter_script.tscn").instantiate())
	await get_tree().create_timer(0.5).timeout
	$BasicZombie2.get_node("zombie_hp_management").take_damage(275,Node2D.new())
	$lane_3.tile_column_2.tile_ground_occupy.get_node("EvolutionSenderSupportBehavior")._everytime_i_evolve_array_callable.append(Callable(self,"unlocked_already_upgrade"))
	$lane_3.tile_column_2.tile_ground_occupy.get_node("EvolutionSenderSupportBehavior")._when_receiving_boost_array_callable.append(Callable(self,"when_i_got_boost"))
	await get_tree().create_timer(5.5).timeout
	$main_camera/Bubble/text.text = "Pick up the power boost"
	set_process(true)
	$NewPlantUnlockRewardNode._call_this_when_collecting_reward_ArrayCallable.append(Callable(self,"unlock_all_tier_for_peashooter"))
	#Engine.time_scale = 3.0	
	#$main_camera.play_camera()
	#$main_camera.when_starting_callable.append(Callable($sun_falling_behaviour,"start"))


func unlock_all_tier_for_peashooter():
	QuickDataManagement.savemanager.unlock_tier("peashooter","tier2")


func unlocked_already_upgrade():
	if done_tutorial: return
	done_tutorial=true
	set_process(false)
	if evolution:evolution.queue_free()
	$main_camera/Bubble/text.text = "Plants can still evolve even without power boost."
	await get_tree().create_timer(4.0).timeout
	$main_camera/Bubble/text.text = "Each plants require certain condition in order for them to evolve"
	await get_tree().create_timer(4.0).timeout
	$main_camera/Bubble.hide()
	$main_camera.play_camera()
	$main_camera.when_starting_callable.append(Callable($sun_falling_behaviour,"start"))

func when_i_got_boost():
	$main_camera/Bubble/text.text = "Now this peashooter is boosted. Press and hold that peashooter and select any upgrade you want for peashooter"

func pick_up_power_unlocked():
	if QuickDataManagement.evolution_power_point >= 1: 
		pickup_power = true
		$main_camera/Bubble/text.text = "Use power boost to boost peashooter evolution."
