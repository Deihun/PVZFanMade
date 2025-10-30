extends CharacterBody2D

var base_expiration_countdown := 80
var current_base_expiration_countdown := 80

func _process(delta: float) -> void:
	if $Detection_Area2.number_detected > 0:
		$PuffshroomAnimation.shoot(($PlantDamageNodeManager.bonus_attackspeed * 0.0099), true)

func _ready() -> void:
	if get_tree().current_scene.is_in_group("daytime"):
		base_expiration_countdown = 25
	current_base_expiration_countdown = base_expiration_countdown
	add_to_group("plant")
	add_to_group("mushroom")
	await get_tree().create_timer(0.01).timeout
	$CollisionShape2D.disabled = false
	$plant_health_management_behaviour._alternative_for_death.append(Callable($PuffshroomAnimation,"play_death"))
	$PuffshroomAnimation.spawn()


func get_base_puff_attack (_damage := int($PlantDamageNodeManager.damage) )-> Node2D:
	var puff : Node2D
	var mobility_script =load("res://Behaviour/projectile_behaviour/projectile_moving_steadily.tscn").instantiate()
	mobility_script.travel_limit_enable = true
	mobility_script.fade_out_when_nearing_end = true
	mobility_script.enable_slowing_down=true
	mobility_script.travel_limit_value = 130
	mobility_script.set_moode = "DELETE_PARENT"

	puff = $projectile_spawn_position/Projectile.duplicate()
	puff.damage = _damage
	puff.monitoring = true
	puff.monitorable = true
	puff.add_to_group("ally_projectile")
	puff.show()
	puff.add_child(mobility_script)
	
	current_base_expiration_countdown = min((3+current_base_expiration_countdown),base_expiration_countdown)
	_check_expiration()
	return puff

func _on_death_on_trample_body_entered(body: Node2D) -> void: 
	if body: if body.is_in_group("testing"):return
	$CollisionShape2D.disabled = true
	$PuffshroomAnimation.play_death()

func _on_puffshroom_animation_puffshoot() -> void:
	var puff = get_base_puff_attack()
	get_tree().current_scene.add_child(puff)
	puff.global_position = $projectile_spawn_position.global_position


func _on_puffshroom_animation_death() -> void:
	self.queue_free()


func _on_expiration_countdown_timeout() -> void:
	current_base_expiration_countdown -= 1
	_check_expiration()

func _check_expiration()-> void:
	if current_base_expiration_countdown > base_expiration_countdown * 0.75: $PuffshroomAnimation._set_expiration_indication(0.0)
	elif current_base_expiration_countdown < base_expiration_countdown * 0.85 : $PuffshroomAnimation._set_expiration_indication(0.25)
	elif current_base_expiration_countdown < base_expiration_countdown * 0.6 : $PuffshroomAnimation._set_expiration_indication(0.60)
	elif current_base_expiration_countdown < base_expiration_countdown * 0.4 : $PuffshroomAnimation._set_expiration_indication(0.95)
	if current_base_expiration_countdown <= 0: _on_death_on_trample_body_entered(null)
