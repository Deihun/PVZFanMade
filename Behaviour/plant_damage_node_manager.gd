extends Node2D
@export var damage:= 20
@export var base_attack_cooldown := 1.0
@export var crit_rate := 0.0
@export var crit_damage_multiplyer := 1.5
@export var followup_bonus_damage_percent := 0.0
@export var followup_cooldown_reduction_ratio := 0.0
var bonus_attackspeed := 0
var bonus_damage:=0

var kill_count := 0
var when_i_kill_callable : Array[Callable] = []

var _bonus_attackspeed_tracker : Array = []
var _bonus_damage_tracker : Array = []

func add_attackspeed_with_tracker(attackspeed_value: float, code_name : String, auto_remove_within_set_duration := -1)-> void:
	for item in _bonus_attackspeed_tracker:
		if item["code_name"] == code_name: 
			item["attackspeed_value"] += attackspeed_value
			_compute_total_attackspeed_of_tracker()
			return
	var dictionary_stored_value = {
		"code_name": code_name,
		"attackspeed_value" : attackspeed_value,
		"auto_remove_within_set_duration" : auto_remove_within_set_duration}
	_compute_total_attackspeed_of_tracker()
	_bonus_attackspeed_tracker.append(dictionary_stored_value)

func remove_attackspeed_with_tracker(code_name : String) ->void:
	for item in _bonus_attackspeed_tracker:
		if item["code_name"] == code_name: 
			_bonus_attackspeed_tracker.erase(item)
			_compute_total_attackspeed_of_tracker()
			return

func get_current_attackspeed_value_with_tracker(code_name :String)-> float:
	for item in _bonus_attackspeed_tracker:
		if item["code_name"] == code_name: return  item["attackspeed_value"]
	return 0.0

func _compute_total_attackspeed_of_tracker()-> void:
	var start_attackspeed:float = 0.0
	for item in _bonus_attackspeed_tracker: 
		start_attackspeed += item["attackspeed_value"]
	bonus_attackspeed = start_attackspeed



func add_damage_with_tracker(damage_value: float, code_name : String, auto_remove_within_set_duration := -1)-> void:
	for item in _bonus_damage_tracker:
		if item["code_name"] == code_name: 
			item["damage_value"] += damage_value
			_compute_total_bonusdamage_of_tracker()
			return
	var dictionary_stored_value = {
		"code_name": code_name,
		"damage_value" : damage_value,
		"auto_remove_within_set_duration" : auto_remove_within_set_duration}
	_compute_total_bonusdamage_of_tracker()
	_bonus_damage_tracker.append(dictionary_stored_value)

func remove_damage_with_tracker(code_name : String) ->void:
	for item in _bonus_damage_tracker:
		if item["code_name"] == code_name: 
			_bonus_damage_tracker.erase(item)
			_compute_total_bonusdamage_of_tracker()
			return
#
func get_current_damage_value_with_tracker(code_name :String)-> float:
	for item in _bonus_damage_tracker:
		if item["code_name"] == code_name: return  item["damage_value"]
	return 0.0
#
func _compute_total_bonusdamage_of_tracker()-> void:
	var start_bonusdamage_count:float = 0.0
	for item in _bonus_damage_tracker: 
		start_bonusdamage_count += item["damage_value"]
	bonus_damage = start_bonusdamage_count

func get_total_computed_bonus_speed(attack_speed_cap : float = 0.1) -> float: 
	return base_attack_cooldown / (1.0+(bonus_attackspeed / 100.0))


func i_successfully_kill_someone():
	kill_count+=1
	for method in when_i_kill_callable: 
		if method.is_valid(): method.call() 
		else: when_i_kill_callable.erase(method)

func get_computed_damage()-> int:
	var computed_damage = damage + bonus_damage
	computed_damage = computed_damage * crit_damage_multiplyer if crit_rate > randf_range(0.01,1.0) else computed_damage
	return computed_damage
