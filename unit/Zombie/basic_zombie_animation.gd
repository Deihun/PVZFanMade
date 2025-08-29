extends Node2D
var played_death : bool =false
var mark_as_flag_zombie := false
var hand_still_attach : bool = true
var walk_callable : Callable
var eat_callable : Callable
var disappear_callable : Callable


@onready var _head_1_sprite:= $BasicZombieBody/node_head/BasicZombieHead1
@onready var _head_2_sprite:= $BasicZombieBody/node_head/BasicZombieHead2
@onready var _arm_front_1_sprite := $BasicZombieBody/ArmFront1
@onready var _arm_front_2_sprite := $BasicZombieBody/ArmFront2
@onready var _body_sprite := $BasicZombieBody
@onready var _arm_back_1_sprite := $ArmBack2/ArmBack1
@onready var _arm_back_2_sprite := $ArmBack2
@onready var _arm_foot_back_sprite := $BasicZombieFootBack
@onready var _arm_foot_front_sprite := $BasicZombieFootFront



@onready var _armor:= $BasicZombieBody/node_head/BasicZombieHead1/armor

func set_flag_zombie():
	mark_as_flag_zombie = true
	$ArmBack2/stored_hold_item/Flag.show()
	$AnimationPlayer.speed_scale = 1.45
	

func _walk():
	if walk_callable.is_valid(): walk_callable.call()

func _death():
	if disappear_callable.is_valid(): disappear_callable.call()

func _trigger_eat():
	if eat_callable.is_valid(): eat_callable.call()

func eat():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("eating_animation")

func walk():
	$AnimationPlayer.stop()
	if mark_as_flag_zombie: $AnimationPlayer.play("Walking_Animation _with_hold_item")
	else: $AnimationPlayer.play("Walking_Animation")

func dead():
	if played_death:return
	played_death=true
	$AnimationPlayer.stop()
	$AnimationPlayer.play("death_animation")
	if get_parent().get_node("zombie_hp_management").lane_rigidbody_collision:
		
		$BasicZombieBody/node_head.rotate(randf_range(0.1,1.0))
		$BasicZombieBody/node_head.gravity_scale =2.0
		$BasicZombieBody/node_head.lock_rotation =  false
		$BasicZombieBody/node_head.collision_mask = get_parent().get_node("zombie_hp_management").lane_rigidbody_collision.collision_layer
		$BasicZombieBody/node_head.collision_mask = get_parent().get_node("zombie_hp_management").lane_rigidbody_collision.collision_layer | (1 << 9)
		var node :  RigidBody2D = $BasicZombieBody/node_head.duplicate()
		var _global_position = $BasicZombieBody.global_position
		var behavior = load("res://Behaviour/projectile_behaviour/thrown_spawn_behavior.tscn").instantiate()
		behavior.disappear_after_3s=true
		get_tree().current_scene.add_child(node)
		node.add_child(behavior)
		node.position= $BasicZombieBody/node_head.position
		node.global_position = $BasicZombieBody/node_head.global_position
		$BasicZombieBody/node_head.queue_free()
	else:
		var node = $BasicZombieBody/node_head.duplicate()
		var _global_position = $BasicZombieBody.global_position
		var behavior = load("res://Behaviour/projectile_behaviour/thrown_spawn_behavior.tscn").instantiate()
		behavior.disappear_after_3s=true
		get_tree().current_scene.add_child(node)
		node.add_child(behavior)
		node.position= $BasicZombieBody/node_head.position
		node.global_position = $BasicZombieBody/node_head.global_position
		$BasicZombieBody.remove_child($BasicZombieBody/node_head)



func base_zombie_is_half():
	if !hand_still_attach:
		return
	var arm : Node2D = $BasicZombieBody/ArmFront2.duplicate()
	var _global_position = $BasicZombieBody/ArmFront2.global_position  #+ $BasicZombieBody/ArmFront2.global_position 
	
	arm.position=Vector2(0,0)
	var behavior = load("res://Behaviour/projectile_behaviour/thrown_spawn_behavior.tscn").instantiate()
	$BasicZombieBody.remove_child($BasicZombieBody/ArmFront2)
	arm.top_level = false
	get_tree().current_scene.add_child(arm)
	arm.position=Vector2(0,0)
	arm.global_position = _global_position
	behavior.disappear_after_3s =true
	arm.add_child(behavior)
	hand_still_attach = false
