extends Node



func popup_zombie_head_animation(master:Node, head_node:Node, head_position_where_it_will_land : Node2D)->void:
	if !master or !head_node: return
	if master.get_parent().get_node("zombie_hp_management").lane_rigidbody_collision:
		head_node.rotate(randf_range(0.1,1.0))
		head_node.gravity_scale =2.0
		head_node.lock_rotation =  false
		head_node.collision_mask = master.get_parent().get_node("zombie_hp_management").lane_rigidbody_collision.collision_layer
		head_node.collision_mask = master.get_parent().get_node("zombie_hp_management").lane_rigidbody_collision.collision_layer | (1 << 9)
		var node :  RigidBody2D = head_node.duplicate()
		var behavior = load("res://Behaviour/projectile_behaviour/thrown_spawn_behavior.tscn").instantiate()
		behavior.disappear_after_3s=true
		get_tree().current_scene.add_child(node)
		node.add_child(behavior)
		node.global_position = head_position_where_it_will_land.global_position
		node.z_index = 3
		head_node.queue_free()
		return
	else:
		var node = head_node.duplicate()
		print(head_position_where_it_will_land.global_position)
		var behavior = load("res://Behaviour/projectile_behaviour/thrown_spawn_behavior.tscn").instantiate()
		behavior.disappear_after_3s=true
		get_tree().current_scene.add_child(node)
		node.add_child(behavior)
		node.global_position = head_position_where_it_will_land.global_position
		node.z_index = 3
		print(node.global_position)
		head_node.queue_free()

func pop_arm_if_half(original_arm : Node, arm_where_it_will_start : Node2D)->void:
	if !original_arm: return
	var arm : Node2D = original_arm.duplicate()
	var _global_position = arm_where_it_will_start.global_position  #+ $BasicZombieBody/ArmFront2.global_position
	arm.position=Vector2(0,0)
	var behavior = load("res://Behaviour/projectile_behaviour/thrown_spawn_behavior.tscn").instantiate()
	original_arm.queue_free()
	arm.top_level = false
	get_tree().current_scene.add_child(arm)
	arm.position=Vector2(0,0)
	arm.global_position = _global_position
	behavior.disappear_after_3s =true
	arm.add_child(behavior)
	arm.z_index = 3

var next_in_line_scene : String 
func enter_new_scene(scene : String) -> void:
	next_in_line_scene = scene
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://HUD/loading_screen/loading_screen.tscn")

func add_limited_plants_on_seeds(seed_packet : Control, effect_when_added : Node2D = null) -> void:
	var camera := get_viewport().get_camera_2d()
	if !camera:
		push_error("-- FailedToAddLimitedSeeds: Unable to detect the camera2D through get_viewport()") 
		return
	if camera.get_node("HUD_normal_selection"):
		push_error("-- FailedToAddLimitedSeeds: failed to find 'HUD_normal_selection' node in main camera: ",camera)
	var seed_slot_container = camera.get_node("HUD_normal_selection").get_node("mode_normal_pick").get_node("plant_seed_selection").get_node("VBoxContainer")
	var _seed_packet = _check_for_seed_packet_duplication(seed_slot_container,seed_packet)
	if !effect_when_added: return
	_seed_packet.add_child(effect_when_added)

func _check_for_seed_packet_duplication(seed_slot_container: VBoxContainer, seed_packet : Control) -> Control:
	for child in seed_slot_container.get_children():
		if child is Control:
			if child.plant_name == seed_packet.plant_name and child.limited_amount >0:
				if child.cooldown== seed_packet.cooldown and child.start_up_cooldown== seed_packet.start_up_cooldown and child.suncost== seed_packet.suncost:
					child._handle_amount_label(child.limited_amount + 1) 
					return child

	seed_slot_container.add_child(seed_packet)
	seed_packet._handle_amount_label(1)
	return seed_packet
