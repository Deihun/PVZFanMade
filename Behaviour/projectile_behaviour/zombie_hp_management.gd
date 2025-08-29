extends Node2D
@export var head_attachment_for_holding_armor : Node2D
@export var zombie_animation_node : Node2D
var take_damage_Callable : Array[Callable] = []
var zombie_death_callable : Array[Callable] = []
var other_type_zombie_death_callable : Array[Callable] = []
var last_death_function : String ="normal"
var last_to_perform_damage : Node2D
@export var HP : int = 300

var lane_rigidbody_collision : StaticBody2D


func take_damage(value:int, last_plant_to_perform_damage ,truedamage:bool = false) -> bool:
	if !truedamage: value = _perform_damage_on_armor_first(value)
	if value > 0: for method in take_damage_Callable: if method.is_valid():method.call()
	HP -= value 
	if last_plant_to_perform_damage: last_to_perform_damage = last_plant_to_perform_damage
	if zombie_animation_node:
		zombie_animation_node.modulate.a = 0.5
		$Timer.start()
	return _check_if_zombie_died()

func _check_if_zombie_died() -> bool:
	if HP <= 0: 
		if last_to_perform_damage: 
			if last_to_perform_damage.has_node("PlantDamageNodeManager"): last_to_perform_damage.get_node("PlantDamageNodeManager").i_successfully_kill_someone()
		match last_death_function:
			"normal":
				for method in zombie_death_callable: if method.is_valid():method.call()
			"other":
				if other_type_zombie_death_callable.size() <=0:
					last_death_function= "normal"
					_check_if_zombie_died()
				else: for method in other_type_zombie_death_callable: if method.is_valid():method.call()
			_: 
				for method in zombie_death_callable: if method.is_valid():method.call()
		return true
		last_death_function = "normal"
	return false

func _perform_damage_on_armor_first(value: int) -> int:
	var current_damage_calculation := value
	for armor in head_attachment_for_holding_armor.get_children():
		if  armor.has_method("take_damage"):
			current_damage_calculation = max(0, armor.call("take_damage", current_damage_calculation))
			if current_damage_calculation == 0:
				return 0
		else: 
			armor.queue_free()
	return current_damage_calculation

func _add_cone_head_armor():
	if !head_attachment_for_holding_armor: return
	var cone_head = load("res://unit/Zombie/basic_zombie/cone_head_armor.tscn").instantiate()
	head_attachment_for_holding_armor.add_child(cone_head)
	head_attachment_for_holding_armor.z_index=5

func _func_add_bucket_head():
	if !head_attachment_for_holding_armor: return
	var cone_head = load("res://unit/Zombie/basic_zombie/bucket_head.tscn").instantiate()
	head_attachment_for_holding_armor.add_child(cone_head)
	head_attachment_for_holding_armor.z_index=5

func _add_armor_custom(armor : Node2D):
	
	if !head_attachment_for_holding_armor: return
	if !armor.has_method("take_damage") or !armor.has_method("check_for_damage_number"): 
		push_error("CustomArmor '",armor,"' unable to be added due to missing script or method")
		return
	var children_count_of_current_armor : int = head_attachment_for_holding_armor.get_child_count()
	head_attachment_for_holding_armor.add_child(armor)
	armor.z_index = 5
	head_attachment_for_holding_armor.z_index=5
	for hat in head_attachment_for_holding_armor.get_children():
		if hat == armor:continue
		hat.position+= Vector2(4, -12)
	#armor.position = Vector2((children_count_of_current_armor * 4),-(children_count_of_current_armor * 12))


func _on_timer_timeout() -> void:
	if zombie_animation_node:zombie_animation_node.modulate.a=1.0
