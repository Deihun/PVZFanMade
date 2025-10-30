extends CharacterBody2D

func _process(delta: float) -> void:
	if $Detection_Area2.number_detected > 0:
		$FumeshroomAnimation._attack(($PlantDamageNodeManager.bonus_attackspeed * 0.0099), !$EvolutionSenderSupportBehavior._tier3a_obtain)

func _ready() -> void:
	add_to_group("plant")
	add_to_group("mushroom")
	await get_tree().create_timer(0.01).timeout
	$collision.disabled = false
	$EvolutionSenderSupportBehavior.tier1A_callable=Callable(self,"_tier1A")
	$EvolutionSenderSupportBehavior.tier2A_callable=Callable(self,"_tier2A")
	$EvolutionSenderSupportBehavior.tier3A_callable=Callable(self,"_tier3A")
	$EvolutionSenderSupportBehavior.tier1B_callable=Callable(self,"_tier1B")
	$EvolutionSenderSupportBehavior.tier2B_callable=Callable(self,"_tier2B")
	$EvolutionSenderSupportBehavior.tier3B_callable=Callable(self,"_tier3B")
	$FumeshroomAnimation._trigger_spawn()

func _trigger_base_attack(pierce :int) -> void:
	var fumes = get_base_fume_attack(pierce)
	get_tree().current_scene.add_child(fumes)
	fumes.global_position = $projectile_spawn_position.global_position

func get_base_fume_attack (pierce : int, _damage := int($PlantDamageNodeManager.damage / 4))-> Node2D:
	var texture_randomizer = ["res://unit/plant/Fumeshroom/projectile_1.png", "res://unit/plant/Fumeshroom/projectile_2.png", "res://unit/plant/Fumeshroom/projectile_3.png"]
	$projectile_spawn_position/Projectile/projectile.texture = load(texture_randomizer.pick_random())
	var fume : Node2D
	var mobility_script =load("res://Behaviour/projectile_behaviour/projectile_moving_steadily.tscn").instantiate()
	mobility_script.travel_limit_enable = true
	mobility_script.fade_out_when_nearing_end = true
	mobility_script.enable_slowing_down=true
	mobility_script.travel_limit_value = 135
	mobility_script.set_moode = "DELETE_PARENT"

	fume = $projectile_spawn_position/Projectile.duplicate()
	fume.pierce = pierce
	fume.damage = _damage
	fume.monitoring = true
	fume.monitorable = true
	fume.add_to_group("ally_projectile")
	fume.add_to_group("fume")
	fume.show()
	fume.add_child(mobility_script)
	return fume





func _tier1A():
	pass
func _tier2A():
	pass
func _tier3A():
	$FumeshroomAnimation._set_to_gloomshroom()
	$Detection_Area2/gloomshroom_detection.disabled = false
	$Detection_Area2/Tier2B.disabled =true
	$Detection_Area2/CollisionShape2D.disabled = true


func _tier1B():
	pass
func _tier2B():
	pass
func _tier3B():
	pass



func _on_fumeshroom_animation_shoot_fume_1() -> void:
	_trigger_base_attack(5)


func _on_fumeshroom_animation_shoot_fume_2() -> void:
	_trigger_base_attack(4)

func _on_fumeshroom_animation_shoot_fume_3() -> void:
	_trigger_base_attack(3)


func _on_fumeshroom_animation_shoot_fume_4() -> void:
	_trigger_base_attack(2)

func _on_fumeshroom_animation_shoot_additional_fume() -> void:
	pass # Replace with function body.


func _on_fumeshroom_animation_shoot_gloomshroom_fume() -> void:
	$Gloomshroom_attacks/CollisionShape2D.disabled = false
	$Gloomshroom_attacks/Timer.stop()
	$Gloomshroom_attacks/Timer.start()


func _on_timer_timeout() -> void:
	$Gloomshroom_attacks/CollisionShape2D.disabled = true


func _on_gloomshroom_attacks_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie"):
		var hp = body.get_node("zombie_hp_management")
		if hp:
			hp.take_damage(($PlantDamageNodeManager.damage * 2.5),self)
