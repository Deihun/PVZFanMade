extends CharacterBody2D


var chill_duration : float = 2.5
var chill_effectiveness : float = 0.9
var freeze_t2b_duration : float = 5.0
var applied_damage_t2b : int = 0.0
var _T3A_counter : int = 0
var _iceberg_seedpacket_T3B

func _process(delta: float) -> void:
	if $Detection_Area2.number_detected > 0:
		$SnowpeaAnimation.trigger_shoot(($PlantDamageNodeManager.bonus_attackspeed * 0.0099))

func _ready() -> void:
	add_to_group("plant")
	await get_tree().create_timer(0.01).timeout
	$CollisionShape2D.disabled = false
	$SnowpeaAnimation.spawn()
	$SnowpeaAnimation._shoot_snow_call = Callable(self,"_release_shoot_ice_pea")
	$EvolutionSenderSupportBehavior.tier1A_callable=Callable(self,"_tier1A")
	$EvolutionSenderSupportBehavior.tier2A_callable=Callable(self,"_tier2A")
	$EvolutionSenderSupportBehavior.tier3A_callable=Callable(self,"_tier3A")
	$EvolutionSenderSupportBehavior.tier1B_callable=Callable(self,"_tier1B")
	$EvolutionSenderSupportBehavior.tier2B_callable=Callable(self,"_tier2B")
	$EvolutionSenderSupportBehavior.tier3B_callable=Callable(self,"_tier3B")

func _release_shoot_ice_pea() -> void:
	var snow_pea = _get_snow_pea_projectile()
	get_tree().current_scene.add_child(snow_pea)
	snow_pea.global_position = $projectile_spawn_position.global_position

func _get_snow_pea_projectile() -> Node2D:
	_T3A_counter = _T3A_counter+1 if _T3A_counter < 3 else 0
	var snowpea
	if _T3A_counter == 3 and $EvolutionSenderSupportBehavior._tier3a_obtain:
		snowpea = $projectile_spawn_position/T3A_Icicle.duplicate()
		var mobility_script =load("res://Behaviour/projectile_behaviour/projectile_moving_steadily.tscn").instantiate()
		snowpea.monitoring = true
		snowpea.monitorable = true
		snowpea.damage = $PlantDamageNodeManager.get_computed_damage()
		snowpea.add_to_group("ally_projectile")
		snowpea.add_to_group("ice")
		snowpea.show()
		snowpea.on_enemy_hit_effect.connect(func(node: Node2D): 
			if !(node is CharacterBody2D): return
			var movement_handler = node.get_node("zombie_movement_management")
			if movement_handler: 
				t2a_t1b_synsergy(node)
				movement_handler.apply_chill(chill_duration, chill_effectiveness)
				movement_handler.apply_freeze(1.0)
			first_time_slowed_that_zombie(node)
			_tier2B_trigger(node)
			)
		snowpea.add_child(mobility_script)
	else:
		snowpea = $projectile_spawn_position/Projectile.duplicate()
		var mobility_script =load("res://Behaviour/projectile_behaviour/projectile_moving_steadily.tscn").instantiate()
		snowpea.monitoring = true
		snowpea.monitorable = true
		snowpea.damage = $PlantDamageNodeManager.get_computed_damage()
		snowpea.add_to_group("ally_projectile")
		snowpea.add_to_group("ice")
		snowpea.show()
		snowpea.on_enemy_hit_effect.connect(func(node: Node2D): 
			if !(node is CharacterBody2D): return
			var movement_handler = node.get_node("zombie_movement_management")
			if movement_handler: 
				t2a_t1b_synsergy(node)
				movement_handler.apply_chill(chill_duration, chill_effectiveness)
			first_time_slowed_that_zombie(node)
			_tier2B_trigger(node)
			)
		snowpea.add_child(mobility_script)
	return snowpea

func first_time_slowed_that_zombie(node: Node2D)-> void:
	if node.has_node("snowpea_already_chill"):return
	var _node= Node.new()
	node.add_child(_node)
	_node.name = "snowpea_already_chill"
	$EvolutionSenderSupportBehavior.increase_progress_evolution(10)

# -------
# TIERS HANDLER
# -------

func _tier2B_trigger(node : Node2D)-> void:
	if !$EvolutionSenderSupportBehavior._tier2b_obtain: return
	var get_that_node = node.get_node("snowpea_tier2b_pop_handler")
	if get_that_node: 
		if get_that_node.receive_attack():
			var movement_handler = node.get_node("zombie_movement_management")
			var hp_handler = node.get_node("zombie_hp_management")
			if !movement_handler or !hp_handler: return
			movement_handler.apply_freeze(freeze_t2b_duration)
			hp_handler.take_damage(applied_damage_t2b,self)
	else:
		var t2b_indicators = $snowpea_tier2b_pop_handler.duplicate()
		node.add_child(t2b_indicators)
		t2b_indicators.global_position = node.global_position + Vector2(0,-30)
		t2b_indicators.show()



func t2a_t1b_synsergy(node : Node2D) -> void:
	if !$EvolutionSenderSupportBehavior._tier1b_obtain or !$EvolutionSenderSupportBehavior._tier2a_obtain:return
	var hp_handler = node.get_node("zombie_hp_management")
	var movement_handler = node.get_node("zombie_movement_management")
	if !hp_handler or !movement_handler: return
	if movement_handler.active_cc["chill"].size() > 0: hp_handler.take_damage(5,self)


func _tier1A():
	chill_effectiveness -= 0.15
	freeze_t2b_duration += 2.0
	$SnowpeaAnimation._t1a()
func _tier2A():
	chill_duration += 87.5
	if $EvolutionSenderSupportBehavior._tier1a_obtain : chill_effectiveness -= 0.09
	$SnowpeaAnimation._t2a()
func _tier3A():
	$SnowpeaAnimation._t3a()
	pass


func _tier1B():
	applied_damage_t2b = 80.0
	$PlantDamageNodeManager.add_damage_with_tracker(2,"t1b")
	$SnowpeaAnimation._t1b()
func _tier2B():
	$SnowpeaAnimation._t2b()
func _tier3B():
	$T3B_iceberg_spawn/timer_spawner_of_t3B.start()
	$SnowpeaAnimation._t3b()


func _on_timer_spawner_of_t_3b_timeout() -> void:
	if _iceberg_seedpacket_T3B: return
	var iceberg_seed_packet = preload("res://unit/plant/SnowPea/iceberg_lettuce/iceberg_preset.tscn").instantiate()
	QuickDataManagement.common_called_method.add_limited_plants_on_seeds(iceberg_seed_packet,preload("res://unit/plant/SnowPea/iceberg_lettuce/effect_when_added_iceberg_snowpea_t3b.tscn").instantiate())
	$T3B_iceberg_spawn/timer_spawner_of_t3B.wait_time = randf_range(30,40)
	$SnowpeaAnimation._t3b_iceberg_create_animation()
