extends CharacterBody2D

var zombies_detected_near_me = []
var _scared_timer := 0.0
var _is_waiting := false

func _process(delta: float) -> void:
	if $Detection_Area2.number_detected > 0:
		$ScaredyshroomAnimation.trigger_shoot(($PlantDamageNodeManager.bonus_attackspeed * 0.0099))

func _ready() -> void:
	add_to_group("plant")
	add_to_group("mushroom")
	await get_tree().create_timer(0.01).timeout
	$CollisionShape2D.disabled = false
	$ScaredyshroomAnimation.trigger_spawn()
	if get_tree().current_scene.is_in_group("daytime"): _scared_mechanic(20.0)


func get_base_projectile_attack (_damage := int($PlantDamageNodeManager.damage))-> Node2D:
	var projectile : Node2D
	var mobility_script =load("res://Behaviour/projectile_behaviour/projectile_moving_steadily.tscn").instantiate()

	projectile = $projectile_spawn_position/Projectile.duplicate()
	projectile.damage = _damage
	projectile.monitoring = true
	projectile.monitorable = true
	projectile.add_to_group("ally_projectile")
	projectile.add_child(mobility_script)
	return projectile

func _scared_mechanic(wait_time: float = 0.0) -> void:
	var condition_1 = zombies_detected_near_me.size() > 0
	if wait_time > 0.0:
		_scared_timer += wait_time
	if condition_1 or _scared_timer > 0.0:
		$ScaredyshroomAnimation.trigger_hide()
	else:
		$ScaredyshroomAnimation.trigger_unhide()

	if not _is_waiting and _scared_timer > 0.0:
		_is_waiting = true
		while _scared_timer > 0.0:
			await get_tree().create_timer(0.1).timeout
			_scared_timer -= 0.1
		_is_waiting = false
		_scared_mechanic() 


func _on_scaredyshroom_get_scared_by_body_entered(body: Node2D) -> void:
	if body.is_in_group("ignore"): return
	zombies_detected_near_me.append(body)
	_scared_mechanic()
func _on_scaredyshroom_get_scared_by_body_exited(body: Node2D) -> void:
	zombies_detected_near_me.erase(body)
	_scared_mechanic()

func _on_death_plants_detection_nearby_body_entered(body: Node2D) -> void:
	var p_health_m = body.get_node("plant_health_management_behaviour")
	if !p_health_m: 
		return

	p_health_m.plant_death.connect(func(): #this is a custom signal and it doesnt trigger
		_scared_mechanic(5.0)
		)


func _on_scaredyshroom_animation_shoot() -> void:
	var projectile = get_base_projectile_attack()
	get_tree().current_scene.add_child(projectile)
	projectile.show()
	projectile.global_position = $projectile_spawn_position.global_position
