extends Control

func trigger_hats()-> void:
	for node in QuickDataManagement._amount_of_current_zombie_in_board:
		if !node: 
			QuickDataManagement._amount_of_current_zombie_in_board.erase(node)
			continue
		var hp = node.get_node("zombie_hp_management")
		if hp.current_health <= 0: continue
		var path = "res://unit/Zombie/Coolz_Zombie/coolz_hat_1_variety.tscn" if randi_range(1,2) == 1 else "res://unit/Zombie/Coolz_Zombie/coolz_hat_2_variety.tscn"
		var coolz_effect := preload("res://HUD/main_menu/text_indication_UI.tscn").instantiate()
		get_tree().current_scene.add_child(coolz_effect)
		var hat = load(path).instantiate()
		hp._add_armor_custom(hat)
		coolz_effect.global_position = hat.global_position
		coolz_effect.add_object_inside_label(preload("res://unit/Zombie/Coolz_Zombie/coolz_Shades.tscn").instantiate())
		


func _on_timer_timeout() -> void:
	queue_free()
