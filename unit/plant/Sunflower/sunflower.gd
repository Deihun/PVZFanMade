extends Node2D

var time_it_takes_to_produce_sun : int = 30
var sun_quantity : int = 25

var _shield_value := 200
var sun_last_position :Vector2
var initial_exp_gold_sun := 0.8
var max_exp_gold_sun := 1.2

var _t2a_requirement_sun_for_powerboost := 1650
var _t2a_current_seen_collected_sun := 0

func _ready() -> void:
	position =Vector2(0,0)
	add_to_group("plant")
	$"Sunflower Animation".producing_sun_callable = Callable(self,"produce_sun")
	$"Sunflower Animation".spawn()
	$plant_health_management_behaviour._when_shield_broken.append( Callable(self,"_shield_broken"))
	$EvolutionSenderSupportBehavior.tier1A_callable =Callable(self,"tier1a")
	$EvolutionSenderSupportBehavior.tier1B_callable =Callable(self,"tier1b")
	$EvolutionSenderSupportBehavior.tier2A_callable =Callable(self,"tier2a")
	$EvolutionSenderSupportBehavior.tier2B_callable =Callable(self,"tier2b")
	$EvolutionSenderSupportBehavior.tier3A_callable =Callable(self,"tier3a")
	$EvolutionSenderSupportBehavior.tier3B_callable =Callable(self,"tier3b")
	await get_tree().create_timer(0.8).timeout
	$evolve_timer.start()

func _shield_broken():
	$sun_flower_shield.visible = false


func get_normal_sun() -> Node2D:
	var _sun_node = load("res://Resource/Sun/normal_sun.tscn").instantiate()
	_sun_node.master=self
	get_tree().current_scene.add_child(_sun_node)
	_sun_node.global_position = $T2A_collecting_power_animation.global_position+Vector2(0,-75)
	if $EvolutionSenderSupportBehavior._tier3b_obtain:
		var effect = load("res://unit/plant/Sunflower/_empress_sun_effect.tscn").instantiate()
		var megasun : Callable=Callable(self,"produce_mega_sun")
		var increasedif : Callable=Callable(self,"increase_sunggold_difficulty")
		_sun_node.click_callbacks.append(increasedif)
		_sun_node._when_I_expire_call_functions.append(megasun)
		_sun_node.add_child(effect)
	return _sun_node

func produce_mega_sun():
	var _sun_node = load("res://Resource/Sun/normal_sun.tscn").instantiate()
	
	_sun_node.sun_value = sun_quantity*3
	_sun_node.sun_expiration_value = randf_range(0.8,max_exp_gold_sun)
	_sun_node.modulate = Color.ORANGE
	get_tree().current_scene.add_child(_sun_node)
	
	_sun_node.position = Vector2.ZERO
	_sun_node.global_position = sun_last_position
	

func increase_sunggold_difficulty():
	initial_exp_gold_sun = max(0.2,(initial_exp_gold_sun-0.08))
	max_exp_gold_sun = max(0.45,(initial_exp_gold_sun-0.075))

func _on_suncooldown_produce_timeout() -> void:
	$"Sunflower Animation".release_sun()
	$suncooldown_produce.wait_time = time_it_takes_to_produce_sun
	$suncooldown_produce.start()

func produce_sun():
	var _sun_node = get_normal_sun()
	var get_my_behaviour = load("res://Behaviour/projectile_behaviour/thrown_spawn_behavior.tscn").instantiate()
	get_my_behaviour.max_distance = Vector2(150,150)
	get_my_behaviour.dead_zone_size = Vector2(20,20)
	_sun_node.add_child(get_my_behaviour)
	_sun_node.sun_value = sun_quantity
	if $EvolutionSenderSupportBehavior._tier2b_obtain and $EvolutionSenderSupportBehavior._tier1a_obtain:
		$plant_health_management_behaviour.gain_shield(120)
		$sun_flower_shield.show()

func tier1a():
	time_it_takes_to_produce_sun -= 5
	$plant_health_management_behaviour.max_health = 40
	$plant_health_management_behaviour.current_health = 40
	_t2a_requirement_sun_for_powerboost = 1900

func tier1b():
	sun_quantity += 5
	_shield_value= 350

func tier2a():
	QuickDataManagement.global_calls_manager._when_sun_collected.append(Callable(self,"_when_you_collect_current_sun"))

func tier2b():
	$shield_.start()
	$sun_flower_shield.visible=true
	$plant_health_management_behaviour._taking_damage.append(Callable(self,"cancel_reset"))
	$plant_health_management_behaviour.shield = _shield_value
	

func tier3a():
	$"Sunflower Animation"._play_twin_sunflower()

func tier3b():
	$"Sunflower Animation".golden_sunflower()


func _on_evolve_timer_timeout() -> void:
	$EvolutionSenderSupportBehavior.increase_progress_evolution(1)

func cancel_reset():
	$shield_.stop()
	$shield_.start()


var __t2a_first_phase_already_trigger := false
var __t2a_last_phase_already_trigger := false
func  _when_you_collect_current_sun():
	_t2a_current_seen_collected_sun += QuickDataManagement._value_of_last_collected_sun
	if _t2a_current_seen_collected_sun >= 500 and _t2a_current_seen_collected_sun <1250 and !__t2a_first_phase_already_trigger:
		$T2A_collecting_power_animation/T2A_visual_cd.start()
		$T2A_collecting_power_animation.modulate = Color.WHITE
		$T2A_collecting_power_animation/play_trigger.play("play")
	elif _t2a_current_seen_collected_sun >1250 and !__t2a_last_phase_already_trigger:
		$T2A_collecting_power_animation/T2A_visual_cd.start()
		$T2A_collecting_power_animation.modulate = Color.FIREBRICK
		$T2A_collecting_power_animation/play_trigger.play("play")
	if _t2a_current_seen_collected_sun >= _t2a_requirement_sun_for_powerboost:
		_t2a_current_seen_collected_sun = 0
		__t2a_first_phase_already_trigger=false
		__t2a_last_phase_already_trigger=false
		var powerboost = load("res://HUD/EvolutionUI/EvolutionPowerBoost.tscn").instantiate()
		get_tree().current_scene.add_child(powerboost)
		$T2A_collecting_power_animation/T2A_visual_when_producing.start()
		$"Sunflower Animation".modulate = Color("1ba300")
		await get_tree().create_timer(0.8).timeout
		powerboost.global_position = $T2A_collecting_power_animation.global_position
		if $EvolutionSenderSupportBehavior._tier1a_obtain and randf() < 0.05:
			var powerboost_2 = load("res://HUD/EvolutionUI/EvolutionPowerBoost.tscn").instantiate()
			get_tree().current_scene.add_child(powerboost_2)
			$T2A_collecting_power_animation/T2A_visual_when_producing.start()
			$"Sunflower Animation".modulate = Color("1ba300")
			await get_tree().create_timer(0.8).timeout
			powerboost_2.global_position = $T2A_collecting_power_animation.global_position
	


func _on_sun_aura_body_entered(body: Node2D) -> void:
	if body.is_in_group("plant") and body.has_node("EvolutionSenderSupportBehavior"):
		var evolution = body.get_node("EvolutionSenderSupportBehavior")
		var check = ["SUNFLOWER","SUNSHROOM"]
		if check.has(evolution.plant_name):
			pass


func _on_shield__timeout() -> void:
	$sun_flower_shield.visible=true
	$plant_health_management_behaviour.shield = _shield_value


func _on_t_2a_visual_cd_timeout() -> void:
	__t2a_first_phase_already_trigger = false
	__t2a_last_phase_already_trigger = false


func _on_t_2a_visual_when_producing_timeout() -> void:
	$"Sunflower Animation".modulate = Color.WHITE
