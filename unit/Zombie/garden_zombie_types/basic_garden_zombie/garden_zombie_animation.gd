extends Node2D

@export var _arm_position : Node2D
@export var _head_position : Node2D

var hand_still_attach := true

signal walk
signal eat
signal lawnmower_release
signal starting_lawn_mower
signal remove_hitbox
signal queue_free_me

func play_idle_basic()-> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("idle")

func play_idle_with_lawn_mower()->void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("idle_with_lawnmower")

func walk_animation()-> void:
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation in ["idle","idle_with_lawnmower","eating_animation","death","normal_walk","with_lawnmower_holding","lawnmower_release"]:return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("normal_walk")

func walk_with_lawnmower() -> void:
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation in ["idle","idle_with_lawnmower","eating_animation","death","normal_walk","with_lawnmower_holding","lawnmower_release"]:return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("with_lawnmower_holding")

func free_lawnmower_animation()->void:
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation in ["lawnmower_release","death"]: return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("lawnmower_release")

func eating_animation() -> void:
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation in ["idle","idle_with_lawnmower","eating_animation","death","normal_walk","with_lawnmower_holding","lawnmower_release"]:return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("eating_animation")

func base_zombie_is_half() -> void:
	if !hand_still_attach: return
	hand_still_attach = false
	var arm := $gardenZombie_mainbody/GardenerzombieMainBody/BasicgardenerRightUpperArm/BasicgardenerRightLowerArm
	QuickDataManagement.common_called_method.pop_arm_if_half(arm, _arm_position)
	hand_still_attach = false

func trigger_death_animation()-> void:
	var head_node := $gardenZombie_mainbody/GardenerzombieMainBody/head
	if !head_node: return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("death")
	$head_popout_sfx.play()
	QuickDataManagement.common_called_method.popup_zombie_head_animation(self,head_node,_head_position)



func get_animation_player()->AnimationPlayer:
	return $AnimationPlayer

func get_armor_node()-> Node2D:
	return $gardenZombie_mainbody/GardenerzombieMainBody/head/BasicgardenerHead1/armor





func _trigger_walk_signal()->void:
	walk.emit()

func _trigger_lawnmower_release()-> void:
	lawnmower_release.emit()

func _trigger_starting_lawn_mower()-> void:
	starting_lawn_mower.emit()

func _trigger_remove_hitbox()->void:
	remove_hitbox.emit()

func _trigger_queue_free_me()->void:
	queue_free_me.emit()

func _trigger_eat()->void:
	eat.emit()
