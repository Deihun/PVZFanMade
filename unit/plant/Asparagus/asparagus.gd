extends CharacterBody2D

func _process(delta: float) -> void:
	if $Detection_Area.zombies_inside.size() > 0:
		_shoot_on_command()

func _ready() -> void:
	$AsparagusAnimation.spawn()
	add_to_group("plant")
	$EvolutionSenderSupportBehavior.tier1A_callable=Callable(self,"_tier1A")
	$EvolutionSenderSupportBehavior.tier2A_callable=Callable(self,"_tier2A")
	$EvolutionSenderSupportBehavior.tier3A_callable=Callable(self,"_tier3A")
	$EvolutionSenderSupportBehavior.tier1B_callable=Callable(self,"_tier1B")
	$EvolutionSenderSupportBehavior.tier2B_callable=Callable(self,"_tier2B")
	$EvolutionSenderSupportBehavior.tier3B_callable=Callable(self,"_tier3B")

func _shoot_on_command()-> void:
	if $EvolutionSenderSupportBehavior._tier3a_obtain: $AsparagusAnimation.special_shoot($PlantDamageNodeManager.bonus_attackspeed * 0.0099)
	else: $AsparagusAnimation.shoot($PlantDamageNodeManager.bonus_attackspeed * 0.0099)

func _on_asparagus_animation__special_shooted_projectile_signal() -> void:
	var asparagus : Area2D = get_asparagus_projectile()
	var mobility_script =load("res://Behaviour/projectile_behaviour/projectile_moving_steadily.tscn").instantiate()
	get_tree().current_scene.add_child(asparagus)
	asparagus.show()
	asparagus.global_position=$projectile_spawn_location.global_position
	asparagus.add_child(mobility_script)
	if $Detection_Area.zombies_inside.size() <= 0: asparagus.specific_target = null
	else: asparagus.specific_target = $Detection_Area.zombies_inside.pick_random()

func _on_asparagus_animation__shoot_signal() -> void:
	var asparagus : Area2D = get_asparagus_projectile()
	var mobility_script =load("res://Behaviour/projectile_behaviour/projectile_moving_steadily.tscn").instantiate()
	get_tree().current_scene.add_child(asparagus)
	asparagus.show()
	asparagus.global_position=$projectile_spawn_location.global_position
	asparagus.add_child(mobility_script)
	_tier3B_explosion(asparagus)



func get_asparagus_projectile() -> Area2D:
	_tier2A_in_action()
	var asparagus_projectile: Area2D = $projectile_spawn_location/Projectile.duplicate()
	asparagus_projectile.monitoring=true
	asparagus_projectile.monitorable = true
	asparagus_projectile.damage = $PlantDamageNodeManager.get_computed_damage()
	_gain_evolution_progress(asparagus_projectile)
	_tier1B_in_action(asparagus_projectile)
	_tier2B_in_action(asparagus_projectile)
	asparagus_projectile.specific_target =  get_the_closest_zombie()
	
	return asparagus_projectile

func get_the_closest_zombie() -> CharacterBody2D:
	var zombies = $Detection_Area.zombies_inside
	if zombies.is_empty():
		return null
	var rightmost_zombie: CharacterBody2D = null
	var max_x = -INF
	for zombie in zombies:
		if zombie.is_in_group("ignore"):
			continue
		if zombie.global_position.x > max_x:
			max_x = zombie.global_position.x
			rightmost_zombie = zombie
	return rightmost_zombie



func _tier1A():
	$PlantDamageNodeManager.add_damage_with_tracker(15.0,"t1a_asparagus")
	$AsparagusAnimation.tier_1A()
func _tier2A():
	$AsparagusAnimation.tier_2A()
func _tier3A():
	pass


func _tier1B():
	$Tier1B_Grass.show()
	$Tier1B_Grass/AnimationPlayer.play("grass_wave")
func _tier2B():
	$AsparagusAnimation.tier_2B()
	
func _tier3B():
	$AsparagusAnimation.tier_3B()

func _gain_evolution_progress(node: Node2D)-> void:
	node.on_enemy_hit_effect.connect(func(_node: Node2D): 
		if !(_node is CharacterBody2D): return
		var hp_enemy : Node2D = _node.get_node("zombie_hp_management")
		if !hp_enemy:return
		if hp_enemy.current_health <= 0: $EvolutionSenderSupportBehavior.increase_progress_evolution(1.0)
		)

func _tier1B_in_action(node: Node2D)-> void:
	if !$EvolutionSenderSupportBehavior._tier1b_obtain:return
	node.on_enemy_hit_effect.connect(func(_node: Node2D): 
			if !(_node is CharacterBody2D): return
			var hp_enemy : Node2D = _node.get_node("zombie_hp_management")
			if !hp_enemy:return
			if hp_enemy.current_health <= 0:
				var damage_increase = 2.5 if $EvolutionSenderSupportBehavior._tier2a_obtain else 1
				$PlantDamageNodeManager.add_damage_with_tracker(damage_increase,"t1b_asparagus")
				_tier1B_handle_grass_grow()
	)

func _tier1B_handle_grass_grow()-> void:
	var current_stacks : float= $PlantDamageNodeManager.get_current_damage_value_with_tracker("t1b_asparagus")
	if current_stacks < 5: $Tier1B_Grass.texture= load("res://unit/plant/Asparagus/tier1B_grass/grass1.png")
	elif current_stacks >5 and current_stacks < 15:  $Tier1B_Grass.texture= load("res://unit/plant/Asparagus/tier1B_grass/grass_2.png")
	elif current_stacks > 15:  $Tier1B_Grass.texture= load("res://unit/plant/Asparagus/tier1B_grass/grass_3.png")

func _tier2A_in_action()-> void:
	if !$EvolutionSenderSupportBehavior._tier2a_obtain: return
	var increase_damage = 40 if $EvolutionSenderSupportBehavior._tier1a_obtain else 20
	if $Detection_Area.zombies_inside.size() != 1:
		$PlantDamageNodeManager.remove_damage_with_tracker("_tier2A_asparagus")
		$tier2A_innerflame_focus.hide()
		return
	if $PlantDamageNodeManager.get_current_damage_value_with_tracker("_tier2A_asparagus") <= 0.0: 
		$tier2A_innerflame_focus.show()
		$PlantDamageNodeManager.add_damage_with_tracker(increase_damage,"_tier2A_asparagus")

func _tier3B_explosion(node: Node2D)-> void:
	if !$EvolutionSenderSupportBehavior._tier3b_obtain:return
	node.on_enemy_hit_effect.connect(func(_node: Node2D): 
			if !(_node is CharacterBody2D): return
			var hp_enemy : Node2D = _node.get_node("zombie_hp_management")
			if !hp_enemy:return
			if hp_enemy.current_health <= 0:
				var t3b_explode =preload("res://unit/plant/Asparagus/asparagus_t3B/tier_3b_effect.tscn").instantiate()
				_node.add_child(t3b_explode)
	)
func _tier2B_in_action(node: Node2D)-> void:
	if !$EvolutionSenderSupportBehavior._tier2b_obtain:return
	var piercing : Area2D= load("res://unit/plant/Asparagus/t_2b.tscn").instantiate()
	piercing.damage = 15 if $EvolutionSenderSupportBehavior._tier1a_obtain else 5
	piercing.threshhold_limit = 80 if $EvolutionSenderSupportBehavior._tier1b_obtain else 200
	node.add_child(piercing)
