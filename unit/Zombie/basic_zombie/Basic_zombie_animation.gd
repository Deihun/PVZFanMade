extends Node2D
@export var arm_position : Node2D
@export var head_position : Node2D

var played_death : bool =false
var mark_as_flag_zombie := false
var hand_still_attach : bool = true
var walk_callable : Callable
var eat_callable : Callable
var disappear_callable : Callable


@onready var _head_1_sprite:= $BasicZombieBody/RigidBody2D/BasicZombieHead1
@onready var _head_2_sprite:= $BasicZombieBody/RigidBody2D/BasicZombieHead2
@onready var _arm_front_1_sprite := $BasicZombieBody/ArmFront1
@onready var _arm_front_2_sprite := $BasicZombieBody/ArmFront1/ArmFront2
@onready var _body_sprite := $BasicZombieBody
@onready var _arm_back_1_sprite := $ArmBack1
@onready var _arm_back_2_sprite := $ArmBack1/ArmBack2
@onready var _arm_foot_back_sprite := $BasicZombieFootBack
@onready var _arm_foot_front_sprite := $BasicZombieFootFront



@onready var _armor:= $Basic_Zombie/BasicZombieBody/node_head/BasicZombieHead1/armor


func get_armor_node()-> Node2D:
	return $BasicZombieBody/RigidBody2D/BasicZombieHead1/armor

func get_animation_player()->AnimationPlayer:
	return $AnimationPlayer

func set_flag_zombie():
	mark_as_flag_zombie = true
	$ArmBack1/ArmBack2/stored_hold_item/Flag.show()
	$AnimationPlayer.speed_scale = 1.45



func _walk():
	if walk_callable.is_valid(): walk_callable.call()

func _death():
	if disappear_callable.is_valid(): disappear_callable.call()

func _trigger_eat():
	if eat_callable.is_valid(): eat_callable.call()

func eat():
	if played_death:return
	if $AnimationPlayer.current_animation in ["death_animation","eating_animation_with_shield","eating_animation"]: return
	$AnimationPlayer.stop()
	if $BasicZombieBody/shield_items.get_child_count()>0: $AnimationPlayer.play("eating_animation_with_shield")
	else: $AnimationPlayer.play("eating_animation")

func walk():
	if played_death:return
	if $AnimationPlayer.current_animation in ["idle","idle_with_shield","eating_animation_with_shield","death_animation","Walking_Animation","Walking_Animation_with_shield","eating_animation","Walking_Animation _with_hold_item"]: return
	if mark_as_flag_zombie: $AnimationPlayer.play("Walking_Animation _with_hold_item")
	elif $BasicZombieBody/shield_items.get_child_count()>0: $AnimationPlayer.play("Walking_Animation_with_shield")
	else: $AnimationPlayer.play("Walking_Animation")

func dead():
	if played_death:return
	played_death=true
	
	$AnimationPlayer.stop()
	$AnimationPlayer.play("death_animation")
	var head_node := $BasicZombieBody/RigidBody2D
	$head_popout_sfx.play()
	QuickDataManagement.common_called_method.popup_zombie_head_animation(self,head_node,head_position)

func set_idle_animation():
	$AnimationPlayer.stop()
	if $BasicZombieBody/shield_items.get_child_count()> 0: $AnimationPlayer.play("idle_with_shield")
	else:$AnimationPlayer.play("idle")

func base_zombie_is_half():
	if !hand_still_attach:
		return
	hand_still_attach = false
	var arm := $BasicZombieBody/ArmFront1/ArmFront2
	QuickDataManagement.common_called_method.pop_arm_if_half(arm, arm_position)
	hand_still_attach = false

func add_shield_items(object:Node2D)-> void:
	if $BasicZombieBody/shield_items.get_child_count() > 0:return
	$BasicZombieBody/shield_items.add_child(object)


func _on_shield_items_child_exiting_tree(node: Node) -> void:
	if $AnimationPlayer.current_animation=="Walking_Animation_with_shield": $AnimationPlayer.play("Walking_Animation")
	if $AnimationPlayer.current_animation=="eating_animation_with_shield": $AnimationPlayer.play("eating_animation")
