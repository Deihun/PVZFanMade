extends Node2D

@export_enum("basic","conehead","buckethead","Coolz Zombie") var zombie_type_mode : String
@onready var animation := $BasicZombieAnimation
var detected_plant
var damage := 10
var speed = 2.5
var enemy_group = "plant"


@onready var collision_shape = $CollisionShape2D
func _ready() -> void:
	add_to_group("zombie")
	
	$zombie_hp_management.head_attachment_for_holding_armor = $BasicZombieAnimation._armor
	var damage_ : Callable = Callable(self,"_check_for_half_health") 
	var play_death_callable : Callable = Callable(self,"death")
	
	$zombie_hp_management.take_damage_Callable.append(damage_)
	$zombie_hp_management.zombie_death_callable.append(play_death_callable)
	$zombie_hp_management.other_type_zombie_death_callable.append(Callable(self,"death_body_disappear"))
	$BasicZombieAnimation.walk_callable = Callable(self,"_move_forward")
	$BasicZombieAnimation.eat_callable = Callable(self,"eat_plant")
	$BasicZombieAnimation.disappear_callable = Callable(self,"disappear")
	$BasicZombieAnimation.walk()
	await get_tree().create_timer(0.1).timeout
	_set_up_baseOn_type()


func _set_up_baseOn_type():
	match zombie_type_mode:
		"basic":
			pass
		"conehead":
			$zombie_hp_management._add_cone_head_armor()
		"buckethead":
			$zombie_hp_management._func_add_bucket_head()
		"Coolz Zombie":
			animation._head_1_sprite.texture = load("res://unit/Zombie/Coolz Zombie/Coolz_zombie_head_1.png")
			animation._head_2_sprite.texture = load("res://unit/Zombie/Coolz Zombie/coolZ_zombie_head_2.png")
			animation._arm_front_1_sprite.texture = load("res://unit/Zombie/Coolz Zombie/Coolz_arm_back_1.png")
			animation._arm_front_2_sprite.texture = load("res://unit/Zombie/Coolz Zombie/Cool_arm_front_2.png")
			animation._body_sprite.texture = load("res://unit/Zombie/Coolz Zombie/Coolz_zombie_body.png")
			animation._arm_foot_back_sprite.texture= load("res://unit/Zombie/Coolz Zombie/Coolz_zombie_foot_back.png")
			animation._arm_foot_front_sprite.texture= load("res://unit/Zombie/Coolz Zombie/Coolz_zombie_foot_front.png")
			animation._arm_back_1_sprite.texture = load("res://unit/Zombie/Coolz Zombie/Coolz_arm_back_1.png")
			animation._arm_back_2_sprite.texture = load("res://unit/Zombie/Coolz Zombie/Coolz_arm_back_2.png")
			for i in randi_range(2,5):
				$zombie_hp_management._add_armor_custom(load("res://unit/Zombie/Coolz Zombie/coolz_hat.tscn").instantiate())


func _move_forward():
	for i in 20:
		position.x -= speed
		await get_tree().create_timer(0.05).timeout

func eat_plant():
	if !detected_plant:
		detected_plant = null
		$BasicZombieAnimation.walk()
		return
	var plant_health_management = detected_plant.get_node("plant_health_management_behaviour")
	if plant_health_management: plant_health_management.perform_damage(damage)
	else: 
		plant_health_management = detected_plant.get_node("zombie_hp_management")
		if plant_health_management: plant_health_management.take_damage(damage)
		else: 
			print("UNABLE TO DETECT TARGET")

func _check_for_half_health():
	if $zombie_hp_management.HP <= 150:
		$BasicZombieAnimation.base_zombie_is_half()


func death():
	if$CollisionShape2D :$CollisionShape2D.queue_free()
	if$HitPoint : $HitPoint.queue_free()
	if $Bite_Detection: $Bite_Detection.queue_free()
	$BasicZombieAnimation.dead()
	detected_plant = null
	if collision_shape: collision_shape.queue_free()

func death_body_disappear():
	death()
	$BasicZombieAnimation.hide()

func disappear():
	queue_free()

func _on_bite_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group(enemy_group) and !body.is_in_group("untargettable") and !body.is_in_group("testing"):
		detected_plant = body
		$BasicZombieAnimation.eat()

func _on_bite_detection_body_exited(body: Node2D) -> void:
	if body == detected_plant and detected_plant: detected_plant =null
