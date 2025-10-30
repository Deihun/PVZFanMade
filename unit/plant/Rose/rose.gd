extends CharacterBody2D

func _process(delta: float) -> void:
	if $Detection_Area2.zombies_inside.size() > 0:
		$RoseAnimation.play_attack()

func release_magic(damage : int = int($PlantDamageNodeManager.get_computed_damage() * 2)) -> Node2D:
	$projectile_spawn_position/Projectile/AnimationPlayer.speed_scale = randf_range(0.8,3.0)
	var magic_missile : Node2D
	var mobility_script =load("res://Behaviour/projectile_behaviour/seeking_behaviour.tscn").instantiate()
	var timer : Timer = Timer.new()
	timer.wait_time = 15.0
	timer.one_shot = true
	timer.autostart = true

	magic_missile = $projectile_spawn_position/Projectile.duplicate()
	magic_missile.damage = damage
	magic_missile.monitoring = true
	magic_missile.monitorable = true
	magic_missile.add_to_group("ally_projectile")
	magic_missile.add_to_group("magic")
	magic_missile.show()
	magic_missile.add_child(mobility_script)
	magic_missile.add_child(timer)
	timer.timeout.connect(func(): magic_missile.queue_free())

	return magic_missile



func _on_rose_animation_attack() -> void:
	var magic_missile = release_magic()
	get_tree().current_scene.add_child(magic_missile)
	magic_missile.global_position = $projectile_spawn_position.global_position
