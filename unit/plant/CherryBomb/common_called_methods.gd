extends Node

func popup_zombie_head_animation(master:Node, head_node:Node)->void:
	if !master or !head_node: return
	if master.get_parent().get_node("zombie_hp_management").lane_rigidbody_collision:
		head_node.rotate(randf_range(0.1,1.0))
		head_node.gravity_scale =2.0
		head_node.lock_rotation =  false
		head_node.collision_mask = master.get_parent().get_node("zombie_hp_management").lane_rigidbody_collision.collision_layer
		head_node.collision_mask = master.get_parent().get_node("zombie_hp_management").lane_rigidbody_collision.collision_layer | (1 << 9)
		var node :  RigidBody2D = head_node.duplicate()
		var _global_position = head_node.global_position
		var behavior = load("res://Behaviour/projectile_behaviour/thrown_spawn_behavior.tscn").instantiate()
		behavior.disappear_after_3s=true
		get_tree().current_scene.add_child(node)
		node.add_child(behavior)
		node.position= head_node.position
		node.global_position = head_node.global_position
		head_node.queue_free()
		return
	else:
		var node = head_node.duplicate()
		var _global_position = head_node.global_position
		var behavior = load("res://Behaviour/projectile_behaviour/thrown_spawn_behavior.tscn").instantiate()
		behavior.disappear_after_3s=true
		get_tree().current_scene.add_child(node)
		node.add_child(behavior)
		node.position= head_node.position
		node.global_position = head_node.global_position
		head_node.queue_free()

func pop_arm_if_half(original_arm : Node)->void:
	if !original_arm: return
	var arm : Node2D = original_arm.duplicate()
	var _global_position = original_arm.global_position  #+ $BasicZombieBody/ArmFront2.global_position
	arm.position=Vector2(0,0)
	var behavior = load("res://Behaviour/projectile_behaviour/thrown_spawn_behavior.tscn").instantiate()
	original_arm.queue_free()
	arm.top_level = false
	get_tree().current_scene.add_child(arm)
	arm.position=Vector2(0,0)
	arm.global_position = _global_position
	behavior.disappear_after_3s =true
	arm.add_child(behavior)
