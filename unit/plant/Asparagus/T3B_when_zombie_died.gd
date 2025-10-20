extends Node2D


func _exit_tree() -> void:
	var evolve_boost = load("res://unit/plant/Asparagus/asparagus_t3B/tier_3b_effect.tscn").instantiate()
	get_tree().current_scene.add_child(evolve_boost)
	evolve_boost.global_position = get_parent().global_position
	evolve_boost.show()


func _on_tree_entered() -> void:
	await get_tree().create_timer(0.05).timeout
	var node = get_parent().get_node("zombie_hp_management")
	if node and node.is_in_group("zombie"): 
		node.zombie_death_callable.append(Callable(self,"_exit_tree"))
		
