extends Node2D

signal when_zombie_died(my_selft : Node2D, last_hitter : Node2D)

@export var zombie_animation_node : Node

var take_damage_Callable : Array[Callable] = []
var zombie_death_callable : Array[Callable] = []
var other_type_zombie_death_callable : Array[Callable] = []
var last_death_function : String ="normal"
var last_to_perform_damage : Node2D



@export var max_health := 300
var current_health : int = 300

var lane_rigidbody_collision : StaticBody2D


func _ready() -> void:
	current_health = max_health

func take_damage(value:int, last_plant_to_perform_damage ,truedamage:bool = false) -> bool:
	if $Label.visible:
		var text := preload("res://HUD/main_menu/text_indication_UI.tscn").instantiate()
		$Label.add_child(text)
		text.set_text(str(value))
	if !truedamage: value = _perform_damage_on_armor_first(value)
	if value > 0: for method in take_damage_Callable: if method.is_valid():method.call()
	current_health -= value 
	if last_plant_to_perform_damage: last_to_perform_damage = last_plant_to_perform_damage
	zombie_animation_node.material.set("shader_parameter/white_override",true)
	$Timer.start()
	$max_health_condition_handler._check_health_conditions()
	$Label.text = str("HP: ",max_health,"/",current_health)

	return _check_if_zombie_died()



func _check_if_zombie_died() -> bool:
	if current_health <= 0: 
		
		if last_to_perform_damage: 
			if last_to_perform_damage.has_node("PlantDamageNodeManager"): 
				last_to_perform_damage.get_node("PlantDamageNodeManager").i_successfully_kill_someone()
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
		when_zombie_died.emit(self,last_to_perform_damage)
		return true
		last_death_function = "normal"
	return false

func _perform_damage_on_armor_first(value: int) -> int:
	if !check_if_animationnode_supports_armor(): return value
	var head_attachments : Node2D= zombie_animation_node.get_armor_node()
	if !head_attachments: return 0
	var current_damage_calculation := value
	var children_of_head_attachment : Array = head_attachments.get_children()
	children_of_head_attachment.reverse()
	for armor in children_of_head_attachment:
		if  armor.has_method("take_damage"):
			current_damage_calculation = max(0, armor.call("take_damage", current_damage_calculation))
			if current_damage_calculation == 0:
				return 0
		else: 
			armor.queue_free()
	return current_damage_calculation

func check_if_animationnode_supports_armor()-> bool:
	return zombie_animation_node.has_method("get_armor_node")

func _add_cone_head_armor():
	if !check_if_animationnode_supports_armor(): 
		return
	_add_armor_custom(preload("res://unit/Zombie/basic_zombie/cone_head_armor.tscn").instantiate())




func _func_add_bucket_head():
	if !check_if_animationnode_supports_armor(): 
		return
	_add_armor_custom(preload("res://unit/Zombie/basic_zombie/bucket_head.tscn").instantiate())

func _add_armor_custom(armor: Node2D) -> void:
	if !check_if_animationnode_supports_armor():
		return
	if !armor.has_method("take_damage") or !armor.has_method("check_for_damage_number"): 
		push_error("CustomArmor '%s' unable to be added due to missing script or method" % armor)
		return

	var head_attachment: Node2D = zombie_animation_node.get_armor_node()
	var old_hats: Array = head_attachment.get_children()

	for hat in old_hats:
		head_attachment.remove_child(hat)

	head_attachment.add_child(armor)
	armor.z_index = 0
	armor.z_as_relative = true
	armor.y_sort_enabled = false
	armor.start_position = zombie_animation_node.head_position.global_position
	armor.global_position = armor.start_position
	armor.position = Vector2.ZERO

	var offset := Vector2(4, -12)

	for i in range(old_hats.size()):
		var hat = old_hats[i]
		head_attachment.add_child(hat)
		hat.position = offset * (i + 1)




func _add_health_threshold_condition(method : Callable, maxhealth_threshold_percent : float, priority_number := 0, trigger_once := false) -> void:
	$max_health_condition_handler._health_threshold_conditions.append({
		"callable": method,
		"threshold_percent": maxhealth_threshold_percent,
		"priority": priority_number,
		"trigger_once": trigger_once,
		"triggered": false
	})
	$max_health_condition_handler._health_threshold_conditions.sort_custom(Callable(self, "_sort_health_conditions")) 


func _on_timer_timeout() -> void:
	zombie_animation_node.material.set("shader_parameter/white_override",false)


func _carry_a_powerboost()-> void:
	$"..".tree_exiting.connect(func():
		var evolve_boost = load("res://HUD/EvolutionUI/EvolutionPowerBoost.tscn").instantiate()
		var spawn_drop = load("res://Behaviour/power_boost_drop.tscn").instantiate()
		get_tree().root.add_child(evolve_boost) #this is stated as still nu;
		evolve_boost.global_position = get_parent().global_position
		evolve_boost.add_child(spawn_drop)
		pass
		)
		
