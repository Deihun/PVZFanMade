extends Area2D
var _on_death_announce : Array[Callable] = []
var _taking_damage : Array[Callable] = []
var _when_shield_broken : Array[Callable] = []
var _when_i_receive_heal_call_other_methods : Array[Callable] = []
var _when_you_plant_on_me : Array[Callable] = []
var _my_seed_packet : Control

@export var max_health : int = 80
@export var armor : float = 0
@export var shield : int = 0
@export var damage_reduction_ratio : float = 0.0

@export var indicate_when_damage : bool = true
var current_health : int = 80




func _ready() -> void:
	$Healing1.visible=false
	current_health = max_health

func heal(value : int) -> void:
	if current_health != max_health :	$AnimationPlayer.play("start")
	for method in _when_i_receive_heal_call_other_methods:
		if method.is_valid(): method.call()
	current_health = current_health+value if (current_health + value) < max_health else max_health
	$max_health_condition_handler._check_health_conditions()

func heal_maxhealth_percentage(max_health_percentage : float):
	heal((0.01 * max_health_percentage) * max_health)


func perform_damage(value : int, true_damage : bool = false):
	var calculated_damage = _damage_shield(value) if !true_damage else value
	if calculated_damage == 0:return
	for method in _taking_damage:
		if method.is_valid() and calculated_damage >0 : method.call()
	calculated_damage = calculated_damage - (calculated_damage * damage_reduction_ratio)
	calculated_damage = max(1,(calculated_damage - (0.6 * armor)))
	current_health -= calculated_damage		
	check_if_death()
	$max_health_condition_handler._check_health_conditions()
	_show_getting_damage()

func gain_extra_max_health(value:int):
	max_health += value
	current_health = min(max_health,(current_health+value))

func gain_extra_max_health_baseOn_maxhealth(max_health_percentage: float):
	gain_extra_max_health((0.01 * max_health_percentage) * max_health)

func gain_armor(value:int):
	armor += value

func grow_armor_to(value:int):
	armor = value if armor < value else armor

func gain_shield(value : int):
	value = value + (50 * armor)
	shield = max(shield, value)


func _damage_shield(value: int) -> int:
	var left_damage = max(0,value - shield)
	shield = max(0,(shield - value))
	for method in _when_shield_broken: if method.is_valid() and shield <=0: method.call()
	return left_damage

func check_if_death():
	if current_health <= 0:
		for method in _on_death_announce:
			if method.is_valid(): method.call()
		get_parent().queue_free()

func _show_getting_damage() -> void:
	if !indicate_when_damage:
		return
	$when_damage.stop()
	$when_damage.start()
	var parent = get_parent()
	parent.modulate.a = 0.3


func _add_health_threshold_condition(method : Callable, maxhealth_threshold_percent : float, priority_number := 0, trigger_once := false) -> void:
	$max_health_condition_handler._health_threshold_conditions.append({
		"callable": method,
		"threshold_percent": maxhealth_threshold_percent,
		"priority": priority_number,
		"trigger_once": trigger_once,
		"triggered": false
	})
	$max_health_condition_handler._health_threshold_conditions.sort_custom(Callable(self, "_sort_health_conditions")) 


func _on_when_damage_timeout() -> void:
	get_parent().modulate.a = 1.0


func plant_on_me() ->bool:
	for call in _when_you_plant_on_me:
		if call.is_valid():call.call()
		else:_when_you_plant_on_me.erase(call)
	return _when_you_plant_on_me.size() > 0
