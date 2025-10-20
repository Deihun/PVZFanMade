extends Node2D

@export_enum("basic","conehead","buckethead","flag-zombie","Coolz Zombie","trashcan noImps","trashcan w/Imps") var zombie_type_mode : String
var detected_plant
var damage := 10
var speed = 2.5
var enemy_group = "plant"


func _process(delta: float) -> void:
	$animation_node.walk()
	if $Bite_Detection._detected_plants.size()>0: $animation_node.eat()
	

func _ready() -> void:
	_set_up_baseOn_type()
	QuickDataManagement.sound_manager.play_zombie_groan(get_random_audio_stream_groan())
	add_to_group("zombie")
	$zombie_hp_management._add_health_threshold_condition(func(): lose_its_arms(),50, 5, true)
	var play_death_callable : Callable = Callable(self,"death")
	$Bite_Detection.i_detect_plants = Callable(self,"start_eating")
	$zombie_hp_management.zombie_death_callable.append(play_death_callable)
	$zombie_hp_management.other_type_zombie_death_callable.append(Callable(self,"death_body_disappear"))
	$zombie_hp_management.zombie_animation_node.walk_callable = Callable($zombie_movement_management,"move")
	$zombie_hp_management.zombie_animation_node.eat_callable = Callable(self,"eat_plant")
	$zombie_hp_management.zombie_animation_node.disappear_callable = Callable(self,"disappear")
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled=false


func _set_up_baseOn_type():
	var animation = $zombie_hp_management.zombie_animation_node
	match zombie_type_mode:
		"basic":
			pass
		"conehead":
			$zombie_hp_management._add_cone_head_armor()
		"buckethead":
			$zombie_hp_management._func_add_bucket_head()
		"flag-zombie":
			$animation_node.set_flag_zombie()
		"Coolz Zombie":
			animation._head_1_sprite.texture         = preload("res://unit/Zombie/Coolz_Zombie/Coolz_zombiehead_1.png")
			animation._head_2_sprite.texture         = preload("res://unit/Zombie/Coolz_Zombie/coolZ_zombie_head_2.png") 
			animation._arm_front_1_sprite.texture    = preload("res://unit/Zombie/Coolz_Zombie/Coolz_arm_back_1.png") 
			animation._arm_front_2_sprite.texture    = preload("res://unit/Zombie/Coolz_Zombie/Cool_arm_front_2.png") 
			animation._body_sprite.texture           = preload("res://unit/Zombie/Coolz_Zombie/Coolz_zombie_body.png") 
			animation._arm_back_1_sprite.texture     = preload("res://unit/Zombie/Coolz_Zombie/Coolz_arm_back_1.png") 
			animation._arm_back_2_sprite.texture     = preload("res://unit/Zombie/Coolz_Zombie/Coolz_arm_back_2.png") 
			animation._arm_foot_back_sprite.texture  = preload("res://unit/Zombie/Coolz_Zombie/Coolz_zombie_foot_back.png") 
			animation._arm_foot_front_sprite.texture = preload("res://unit/Zombie/Coolz_Zombie/Coolz_zombie_foot_front.png") 
			for i in randi_range(2,5):
				var variety = "res://unit/Zombie/Coolz_Zombie/coolz_hat_1_variety.tscn" if randi_range(1,2) == 1 else "res://unit/Zombie/Coolz_Zombie/coolz_hat_2_variety.tscn"
				$zombie_hp_management._add_armor_custom(load(variety).instantiate())
		"trashcan noImps":
			$animation_node.add_shield_items(preload("res://unit/Zombie/shields/trashcan.tscn").instantiate())
		"trashca$SubViewportContainer/SubViewport/animation_noden w/Imps":
			var trashcan : Node2D = preload("res://unit/Zombie/shields/trashcan.tscn").instantiate()
			$SubViewport/animation_node.add_shield_items(trashcan)


func _set_as_idle():
	await get_tree().create_timer(randf_range(0.1,1.2)).timeout
	if $_Coolz_Passive: $_Coolz_Passive/indication.stop()
	$CollisionShape2D.disabled =true
	$animation_node.set_idle_animation()

func start_eating():
	$zombie_hp_management.zombie_animation_node.eat()

func eat_plant():
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


func lose_its_arms():
	$animation_node.base_zombie_is_half()


func death():
	add_to_group("ignore")
	if $HitPoint : $HitPoint.queue_free()
	if $Bite_Detection/CollisionShape2D2: $Bite_Detection/CollisionShape2D2.disabled = true
	$animation_node.dead()
	detected_plant = null

func death_body_disappear():
	death()
	$animation_node.hide()

func disappear():
	queue_free()


func get_random_audio_stream_groan()-> AudioStream:
	match randi_range(1,5):
		1:
			return load("res://unit/Zombie/basic_zombie/basic_zombie_groan_1.mp3")
		2:
			return load("res://unit/Zombie/basic_zombie/basic_zombie_groan_2.mp3")
		3:
			return load("res://unit/Zombie/basic_zombie/basic_zombie_groan_3.mp3")
		4:
			return load("res://unit/Zombie/basic_zombie/basic_zombie_groan_4.mp3")
		5: return load("res://unit/Zombie/basic_zombie/basic_zombie_groan_5.mp3")
	return load("res://unit/Zombie/basic_zombie/basic_zombie_groan_1.mp3")


func _on_groan_value_timeout() -> void:
	$groan_value.wait_time = randf_range(15.0,30.0)
	QuickDataManagement.sound_manager.play_zombie_groan(get_random_audio_stream_groan())
