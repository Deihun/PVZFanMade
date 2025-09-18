extends Node2D

var master 
var damage :int
var pierce : int = 1
var true_damage := false
@export var speed : float =300
var trigger_when_this_projectile_destroyed : Callable

func reduce_pierce(value:int, target_enemy : CharacterBody2D) -> void: 
	pierce -= 1
	if pierce <= 0:
		if trigger_when_this_projectile_destroyed.is_valid(): trigger_when_this_projectile_destroyed.call()
		var get_max := target_enemy.get_node("zombie_hp_management")
		if get_max: get_max.take_damage(damage,master,true_damage)
		var splash= load("res://unit/plant/peashooter/peashooter_pea_effects/pea_splash.tscn").instantiate()
		get_tree().current_scene.add_child(splash)
		splash.global_position = global_position
		self.queue_free()




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie") and !body.is_in_group("ignore"):
		reduce_pierce(1, body)
