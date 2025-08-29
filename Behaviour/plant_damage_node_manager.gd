extends Node2D
@export var damage:= 20
@export var base_attack_cooldown := 1.0
@export var crit_rate := 0.0
@export var crit_damage_multiplyer := 1.5
@export var followup_bonus_damage_percent := 0.0
@export var followup_cooldown_reduction_ratio := 0.0
var bonus_attackspeed := 0
var bonus_damage:=0

var when_i_kill_callable : Array[Callable] = []

func get_total_computed_bonus_speed(attack_speed_cap : float = 0.1) -> float: 
	return base_attack_cooldown / (1.0+(bonus_attackspeed / 100.0))

func i_successfully_kill_someone():
	for method in when_i_kill_callable: 
		if method.is_valid(): method.call() 
		else: when_i_kill_callable.erase(method)

func get_computed_damage()-> int:
	var computed_damage = damage
	computed_damage = computed_damage * crit_damage_multiplyer if crit_rate > randf_range(0.01,1.0) else computed_damage
	return computed_damage
