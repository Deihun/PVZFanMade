extends Node2D

var _chomper_on_attack : Callable
var _i_already_ate_that_zombie : Callable

func _i_already_ate_that_zombie_call()-> void:
	if _i_already_ate_that_zombie.is_valid(): _i_already_ate_that_zombie.call()

func attack_the_front_zombie_call()-> void:
	if _chomper_on_attack.is_valid(): _chomper_on_attack.call()

func _get_arms()-> void:
	var chomper_parent = get_parent()
	if !(chomper_parent is CharacterBody2D) or !chomper_parent.has_method("bite_zombies"):return
	$chomper_whole_body/chomper_head/ChomperLowerHead/zombie_arms_/zombie_1.visible = chomper_parent.amount_of_zombies_im_chewing >= 1
	$chomper_whole_body/chomper_head/ChomperLowerHead/zombie_arms_/zombie_2.visible = chomper_parent.amount_of_zombies_im_chewing >= 2

func _i_can_chew_another()-> bool:
	var chomper_parent = get_parent()
	if !(chomper_parent is CharacterBody2D) or !chomper_parent.has_method("bite_zombies"):return false
	return chomper_parent.amount_of_zombies_im_chewing < chomper_parent.amount_of_zombies_i_can_eat

func _get_the_number_of_chewing()-> int:
	var chomper_parent = get_parent()
	if !(chomper_parent is CharacterBody2D) or !chomper_parent.has_method("bite_zombies"):return 0
	return chomper_parent.amount_of_zombies_im_chewing 


func i_spawn()-> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("spawn")


func i_completely_gulp_a_zombie()-> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("gulping")

func i_devour_zombie()-> void :
	$AnimationPlayer.play("manage_to_eat")

func trigger_attack()-> void:
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation in ["attack","manage_to_eat","gulping", "spawn"]: return
	$AnimationPlayer.play("attack")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["manage_to_eat","chewing"]: $AnimationPlayer.play("chewing")
	if anim_name == "gulping": 
		if _get_the_number_of_chewing() == 0: $AnimationPlayer.play("idle")
		else: $AnimationPlayer.play("chewing")
	if anim_name == "attack": 
		if _get_the_number_of_chewing() == 0: $AnimationPlayer.play("idle")
		else: $AnimationPlayer.play("chewing")
	if anim_name == "spawn": $AnimationPlayer.play("idle")

func t1a()-> void:
	$chomper_whole_body/chomper_head/ChomperLowerHead/ChomperLowerHeadTeeth.texture = load("res://unit/plant/Chomper/t1a_teeth_lower.png")
	$chomper_whole_body/chomper_head/ChomperUpperhead/ChomperUpperheadTeeth.texture = load("res://unit/plant/Chomper/t1a_teeth_upper.png")

func t1b()-> void: 
	$chomper_whole_body/chomper_head/ChomperLowerHead/ChomperLowerHeadTeeth.texture = load("res://unit/plant/Chomper/t1b_teeth_lower.png")
	$chomper_whole_body/chomper_head/ChomperUpperhead/ChomperUpperheadTeeth.texture = load("res://unit/plant/Chomper/t1b_teeth_upper.png")

func t2a()-> void:
	$chomper_whole_body/chomper_head/ChomperLowerHead/T2aGooiiMouth.show()

func t2b()-> void:
	$chomper_whole_body/T2bAura.show()

func t3a()-> void:
	$chomper_whole_body/chomper_head/ChomperLowerHead.self_modulate = Color("65e9e9")
	$chomper_whole_body/chomper_head/ChomperUpperhead.self_modulate = Color("65e9e9")
	$chomper_whole_body/T2bAura.self_modulate = Color("65e9e9")
	$chomper_whole_body/Stem.self_modulate = Color("65e9e9")
	$chomper_whole_body/Stem/ChomperStemGulp.self_modulate = Color("65e9e9")
	$chomper_whole_body/Stem/VinesT3a.show()
	$chomper_whole_body/LeavesBehin.texture= load("res://unit/plant/Chomper/behind_leaves_t3a.png")

func t3b()-> void:
	$chomper_whole_body/chomper_head/ChomperLowerHead.self_modulate = Color("d3ae11")
	$chomper_whole_body/chomper_head/ChomperUpperhead.self_modulate = Color("d3ae11")
	$chomper_whole_body/T2bAura.self_modulate = Color("d3ae11")
	$chomper_whole_body/Stem.modulate = Color("d3ae11")
	$chomper_whole_body/chomper_head/LeavesOnNeck.texture = load("res://unit/plant/Chomper/t3b_neck.png")
