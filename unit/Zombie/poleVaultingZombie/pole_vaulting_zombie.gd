extends CharacterBody2D
var vault_is_use := false

var target_plant


#func _process(delta: float) -> void:
	#if $BiteRange/CollisionShape2D.disabled: return
	#if target_plant: 
		#$SubViewport/PoleVaultZombieAnimation._eating_animation()
		#$zombie_movement_management.__im_eating = true
	#else: $SubViewport/PoleVaultZombieAnimation.walk_animation()


func _ready() -> void:
	var animation_node = $SubViewport/PoleVaultZombieAnimation
	add_to_group("zombie")
	
	$Bite_Detection.i_detect_plants = Callable(self,"start_eating")
	$zombie_hp_management._add_health_threshold_condition(func(): trigger_half(),50, 5, true)
	$zombie_hp_management.zombie_death_callable.append(Callable(self,"death"))
	animation_node._run_callable = Callable($zombie_movement_management,"move")
	animation_node._vaulting_callable = Callable(self,"vaulting")
	animation_node._walk_callable = Callable($zombie_movement_management,"move")
	animation_node._change_hitbox_callable= Callable(self,"change_secondary_hitbox")
	animation_node._eat_callable = Callable(self,"eat_plant")
	animation_node.run_animation()

func start_eating():
	$zombie_hp_management.zombie_animation_node._eating_animation()


func eat_plant():
	var plant = $Bite_Detection.get_target_plant()
	$zombie_movement_management.__im_eating = true
	if !plant:
		$zombie_hp_management.zombie_animation_node.walk_animation()
		return
	
	var plant_health_management = plant.get_node("plant_health_management_behaviour")
	if plant_health_management: plant_health_management.perform_damage(10)
	else: 
		plant_health_management = plant.get_node("zombie_hp_management")
		if plant_health_management: plant_health_management.take_damage(10,self)


func change_secondary_hitbox():
	$character_collision_detect2.disabled = !$character_collision_detect2.disabled

func trigger_half():
	$SubViewport/PoleVaultZombieAnimation._remove_arm()

func death() -> void:
	add_to_group("ignore")
	$character_collision_detect.disabled=true
	$SubViewport/PoleVaultZombieAnimation._death_animation()
	await get_tree().create_timer(1.75).timeout
	queue_free()


var tallnut_encounter := false
func vaulting():
	tallnut_encounter = false
	$plant_for_vaulting_detection/collision.disabled=true
	for i in 10:
		if tallnut_encounter: break
		self.position.x -= 15 
		await get_tree().create_timer(0.018).timeout

func _set_as_idle():
	$character_collision_detect.disabled =true
	$character_collision_detect2.disabled =true
	$SubViewport/PoleVaultZombieAnimation.set_idle_animation()

func _on_plant_for_vaulting_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("plant"):
		$SubViewport/PoleVaultZombieAnimation.vault_animation()
		$zombie_movement_management._amount_of_movement = 2.55
		$zombie_movement_management._movement_repeatition = 20
		await get_tree().create_timer(1.0).timeout
		$Bite_Detection/CollisionShape2D.disabled=false

func _on_plant_for_vaulting_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("plant"):
		$SubViewport/PoleVaultZombieAnimation.vault_animation()
		$zombie_movement_management._amount_of_movement = 2.55
		$zombie_movement_management._movement_repeatition = 20
		await get_tree().create_timer(1.0).timeout
		$Bite_Detection/CollisionShape2D.disabled=false



func _on_check_if_tallnut_body_entered(body: Node2D) -> void:
	if body.is_in_group("plant"):
		var evolution = body.get_node("EvolutionSenderSupportBehavior")
		if evolution:
			if evolution.plant_name == "wallnut" and evolution._tier2a_obtain:
				tallnut_encounter = true




func _on_bite_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("plant"):
		target_plant = body


func _on_bite_range_body_exited(body: Node2D) -> void:
	if body == target_plant:
		target_plant = null
