extends Node2D


var master 
var damage :int = 20
var pierce : int = 1
var true_damage := false
var crit_damage := false
var specific_target : CharacterBody2D 

@export var _after_hit_spawn_trigger_USE_PATH : Array[String]
@export var speed : float =300
@export_file("*.tscn") var after_splash_effect_scene : String

var trigger_when_this_projectile_destroyed : Callable
signal on_enemy_hit_effect(node : Node2D)

func reduce_pierce(value:int, target_enemy : Node2D) -> void: 
	if pierce > 0:
		pierce -= 1
		if pierce <= 0: self.queue_free()
		if trigger_when_this_projectile_destroyed.is_valid(): trigger_when_this_projectile_destroyed.call()
		if target_enemy is CharacterBody2D:
			var get_max := target_enemy.get_node("zombie_hp_management")
			if get_max: get_max.take_damage(damage,master,true_damage)
		elif target_enemy.has_method("take_damage"): target_enemy.take_damage(damage) #how to check if this take_damage _accept three parameters instead of 1?
		on_enemy_hit_effect.emit(target_enemy)
		trigger_splash_effect()
		_trigger_after_spawn()



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie") and !body.is_in_group("ignore"):
		if !_handle_specific_target(body): return
		reduce_pierce(1, body)
		if true_damage:
			var text_indic := preload("res://HUD/main_menu/text_indication_UI.tscn").instantiate()
			text_indic.set_text("TRUE DAMAGE")
			text_indic.set_color_as_damage_indication()  
			get_tree().current_scene.add_child(text_indic)
			text_indic.global_position = body.global_position


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		reduce_pierce(1,area)

func trigger_splash_effect()-> void:
	if after_splash_effect_scene.is_empty() or !after_splash_effect_scene: return
	var splash= load(after_splash_effect_scene).instantiate()
	get_tree().current_scene.add_child(splash)
	splash.z_index=5
	splash.scale = scale
	splash.global_position = global_position

func _trigger_after_spawn() -> void:
	if _after_hit_spawn_trigger_USE_PATH.size() <= 0:return
	for s in _after_hit_spawn_trigger_USE_PATH:
		var after_effects= load(s).instantiate()
		get_tree().current_scene.add_child(after_effects)
		after_effects.scale = scale
		after_effects.global_position = global_position

func _handle_specific_target(current_target) -> bool:
	if !specific_target: return true
	if specific_target == current_target: return true
	return false
