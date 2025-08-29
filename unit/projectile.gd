extends Node2D

var master 
var damage :int
var pierce : int = 1
var true_damage := false
@export var speed : float =300
var trigger_when_this_projectile_destroyed : Callable

func reduce_pierce(value:int): 
	pierce -= 1
	if pierce <= 0:
		if trigger_when_this_projectile_destroyed.is_valid(): trigger_when_this_projectile_destroyed.call()
		self.queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie"):
		var get_max := body.get_node("zombie_hp_management")
		if get_max: get_max.take_damage(damage,master,true_damage)
		reduce_pierce(1)
