extends Node2D

@export_enum("basic","conehead","buckethead","Coolz Zombie") var zombie_type_mode : String
var detected_plant
var damage := 10
var speed = 2.5
var enemy_group = "plant"


@onready var collision_shape = $CollisionShape2D
func _ready() -> void:

	QuickDataManagement.sound_manager.play_zombie_groan(get_random_audio_stream_groan())
	add_to_group("zombie")
	$zombie_hp_management._add_health_threshold_condition(func(): lose_its_arms(),50, 5, true)
	var play_death_callable : Callable = Callable(self,"death")
	$zombie_hp_management.zombie_death_callable.append(play_death_callable)
	$zombie_hp_management.other_type_zombie_death_callable.append(Callable(self,"death_body_disappear"))
	$zombie_hp_management.zombie_animation_node.walk_callable = Callable($zombie_movement_management,"move")
	$zombie_hp_management.zombie_animation_node.eat_callable = Callable(self,"eat_plant")
	$zombie_hp_management.zombie_animation_node.disappear_callable = Callable(self,"disappear")
	$zombie_hp_management.zombie_animation_node.walk()
	await get_tree().create_timer(0.1).timeout
	_set_up_baseOn_type()
	await get_tree().create_timer(1.0).timeout
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
		"Coolz Zombie":
			for i in randi_range(2,5):
				$zombie_hp_management._add_armor_custom(load("res://unit/Zombie/Coolz Zombie/coolz_hat.tscn").instantiate())


func _set_as_idle():
	await get_tree().create_timer(randf_range(0.1,1.2)).timeout
	$CollisionShape2D.disabled =true
	$SubViewport/animation_node.set_idle_animation()


func eat_plant():
	$zombie_movement_management.__im_eating = true
	if !detected_plant:
		detected_plant = null
		$zombie_hp_management.zombie_animation_node.walk()
		return
	var plant_health_management = detected_plant.get_node("plant_health_management_behaviour")
	if plant_health_management: plant_health_management.perform_damage(damage)
	else: 
		plant_health_management = detected_plant.get_node("zombie_hp_management")
		if plant_health_management: plant_health_management.take_damage(damage,self)


func lose_its_arms():
	$SubViewport/animation_node.base_zombie_is_half()


func death():
	add_to_group("ignore")
	if $HitPoint : $HitPoint.queue_free()
	if $Bite_Detection: $Bite_Detection.queue_free()
	$SubViewport/animation_node.dead()
	detected_plant = null

func death_body_disappear():
	death()
	$SubViewport/animation_node.hide()

func disappear():
	queue_free()

func _on_bite_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group(enemy_group) and !body.is_in_group("untargettable") and !body.is_in_group("testing"):
		detected_plant = body
		$zombie_hp_management.zombie_animation_node.eat()

func _on_bite_detection_body_exited(body: Node2D) -> void:
	if body == detected_plant and detected_plant: detected_plant =null

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
