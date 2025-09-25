extends Node2D

var master 
var damage :int
var pierce : int = 1
var true_damage := false
@export var speed : float =300
var trigger_when_this_projectile_destroyed : Callable

func reduce_pierce(value:int, target_enemy : CharacterBody2D) -> void: 
	if pierce > 0:
		pierce -= 1
		if trigger_when_this_projectile_destroyed.is_valid(): trigger_when_this_projectile_destroyed.call()
		var get_max := target_enemy.get_node("zombie_hp_management")
		if get_max: get_max.take_damage(damage,master,true_damage)
		var splash= load("res://unit/plant/peashooter/peashooter_pea_effects/pea_splash.tscn").instantiate()
		get_tree().current_scene.add_child(splash)
		splash.scale = scale
		splash.global_position = global_position
		self.queue_free()




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie") and !body.is_in_group("ignore"):
		reduce_pierce(1, body)
		if true_damage:
			var text_indic := preload("res://HUD/main_menu/text_indication_UI.tscn").instantiate()#this thing work as intended with others but not with this tree_exiting its not showing but this method is still working
			text_indic.set_text("TRUE DAMAGE")
			text_indic.set_color_as_damage_indication()  
			get_tree().current_scene.add_child(text_indic)
			text_indic.global_position = body.global_position



#func _on_tree_exiting() -> void:
	#if true_damage:
		#var text_indic := preload("res://HUD/main_menu/text_indication_UI.tscn").instantiate()#this thing work as intended with others but not with this tree_exiting its not showing but this method is still working
		#text_indic.set_text("TRUE DAMAGE")
		#text_indic.set_color_as_damage_indication()  
		#get_tree().current_scene.add_child(text_indic)
		#text_indic.global_position = global_position
		#print("test")


#func _on_tree_exited() -> void:
