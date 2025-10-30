extends CharacterBody2D

var _night_bonuses := 5
var sun_quantity := 10
var sun_last_position :Vector2
var time_it_takes_to_produce_sun := 27

func _ready() -> void:
	if !get_tree().current_scene.is_in_group("daytime"):
		_night_bonuses = 5
	add_to_group("plant")
	add_to_group("mushroom")
	await get_tree().create_timer(0.01).timeout
	$CollisionShape2D.disabled = false
	$SunshroomAnimation._trigger_spawn()
	_set_timer_to_start_producing_sun()
	$_grow_to_phase2.start()
func get_normal_sun() -> Node2D:
	var _sun_node = load("res://Resource/Sun/normal_sun.tscn").instantiate()
	var get_my_behaviour = load("res://Behaviour/projectile_behaviour/thrown_spawn_behavior.tscn").instantiate()
	get_my_behaviour.max_distance = Vector2(150,150)
	get_my_behaviour.dead_zone_size = Vector2(20,20)
	get_tree().current_scene.add_child(_sun_node)
	_sun_node.add_child(get_my_behaviour)
	_sun_node.sun_value = sun_quantity
	_sun_node.master=self
	_sun_node.global_position = $EvolutionSenderSupportBehavior.global_position
	sun_last_position = _sun_node.global_position
	return _sun_node
func _set_timer_to_start_producing_sun()-> void:
	var base_time = time_it_takes_to_produce_sun
	if _night_bonuses > 0:
		_night_bonuses -= 1
		base_time  = 5.0
	$sun_production.wait_time = base_time
	$sun_production.start()






func _on_sunshroom_animation_produce_sun() -> void:
	get_normal_sun()
func _on_sun_production_timeout() -> void:
	_set_timer_to_start_producing_sun()
	$SunshroomAnimation.trigger_to_produce_sun()
func _on__grow_to_phase_2_timeout() -> void:
	sun_quantity += 5
	$SunshroomAnimation.grow_to_second_phase()
	$_grow_to_phase3.start()
func _on__grow_to_phase_3_timeout() -> void:
	sun_quantity += 10
	$SunshroomAnimation.grow_to_last_phase()
	$_evolve_timer.start()
