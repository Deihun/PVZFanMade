extends CharacterBody2D

@export_enum("basic","conehead","buckethead","lawn_mower_gardener","pesticide_control") var zombie_type_mode : String = "basic"
var _lawnmown_current_times := 900
var _lawn_mown_already_trigger := false
var damage := 10

func _ready() -> void:
	add_to_group("zombie")
	_setup_base_on_types()
func _process(delta: float) -> void:
	_zombie_perform_action()

func _setup_base_on_types() -> void:
	$animation_node.walk.connect(Callable($zombie_movement_management,"move"))
	$zombie_hp_management._add_health_threshold_condition(func(): $animation_node.base_zombie_is_half(),50, 5, true)
	match zombie_type_mode:
		"conehead":pass
		"buckethead" : pass
		"lawn_mower_gardener": 
			$lawnmower_collision/CollisionShape2D.disabled = false
			_lawnmown_current_times= randi_range(60,100)
			$lawnmower_timer.start()
		"pesticide_control" : pass
	
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled=false



func _zombie_perform_action() -> void:
	if zombie_type_mode == "lawn_mower_gardener":
		if $lawnmower_timer.is_stopped(): $lawnmower_timer.start()
		$animation_node.walk_with_lawnmower()
	pass


func _on_lawnmower_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_spawn_checker") or body.is_in_group("testing"): return
	body.add_to_group("ignore")
	var hp = body.get_node("zombie_hp_management")
	var lawning_effect = preload("res://unit/Zombie/garden_zombie_types/zombie_lawnmower/z_lawn_mower_killed_animation.tscn").instantiate()
	get_tree().current_scene.remove_child(body)
	lawning_effect.add_child(body)
	body.position = Vector2.ZERO
	add_child(lawning_effect)
	lawning_effect.global_position = $lawnmower_collision/CollisionShape2D.global_position 
	if hp: hp.take_damage(90000,null)


func _on_garden_zombie_animation_eat() -> void:
	var plant = $Bite_Detection.get_target_plant()
	$zombie_movement_management.__im_eating = true
	if !plant:
		$zombie_hp_management.zombie_animation_node.walk()
		return
	var plant_health_management = plant.get_node("plant_health_management_behaviour")
	if plant_health_management: plant_health_management.perform_damage(damage)
	else: 
		plant_health_management = plant.get_node("zombie_hp_management")
		if plant_health_management: plant_health_management.take_damage(damage,self)
	QuickDataManagement.sound_manager.play_bite_sound_effect()

func _on_garden_zombie_animation_lawnmower_release() -> void:
	var zlawnmower : CharacterBody2D = load("res://unit/Zombie/garden_zombie_types/zombie_lawnmower/Z_lawnmower.tscn").instantiate()
	get_tree().current_scene.add_child(zlawnmower)
	zlawnmower.global_position= $lawnmower_collision/CollisionShape2D.global_position + Vector2(0,25)
	


func _on_garden_zombie_animation_queue_free_me() -> void:
	queue_free()


func _on_garden_zombie_animation_remove_hitbox() -> void:
	add_to_group("ignore")


func _on_lawnmower_timer_timeout() -> void:
	_lawnmown_current_times -= 1
	if _lawnmown_current_times <= 0:
		$lawnmower_timer.stop()
		$animation_node.free_lawnmower_animation()


func _on_zombie_movement_management_unable_to_move_for_given_seconds(seconds: float) -> void:
	if _lawnmown_current_times > 0 and zombie_type_mode== "lawn_mower_gardener":
		_lawnmown_current_times += seconds + (seconds * 0.5)

func _set_as_idle() -> void:
	if zombie_type_mode == "lawn_mower_gardener": 
		$animation_node.play_idle_with_lawn_mower()
	else: $animation_node.play_idle_basic()


func _on_zombie_hp_management_when_zombie_died(my_selft: Node2D, last_hitter: Node2D) -> void:
	add_to_group("ignore")
	$animation_node.trigger_death_animation()
