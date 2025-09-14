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

func get_animation_player()->AnimationPlayer:
	return $AnimationPlayer

func set_flag_zombie():
	mark_as_flag_zombie = true
	$ArmBack2/stored_hold_item/Flag.show()
	$AnimationPlayer.speed_scale = 1.45

func play_bite_sound_effect():
	var bite : Array[AudioStreamPlayer] = [$bite_1,$bite_2]
	bite.pick_random().play()

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
	if $AnimationPlayer.current_animation == "idle": return
	if $AnimationPlayer.current_animation == "death_animation": return
	$AnimationPlayer.stop()
	if mark_as_flag_zombie: $AnimationPlayer.play("Walking_Animation _with_hold_item")
	else: $AnimationPlayer.play("Walking_Animation")

func dead():
	if played_death:return
	played_death=true
	$AnimationPlayer.stop()
	$AnimationPlayer.play("death_animation")
	var head_node := $BasicZombieBody/node_head
	$head_popout_sfx.play()
	QuickDataManagement.common_called_method.popup_zombie_head_animation(self,head_node)

func set_idle_animation():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("idle")

func base_zombie_is_half():
	if !hand_still_attach:
		return
	hand_still_attach = false
	var arm := $BasicZombieBody/ArmFront2
	QuickDataManagement.common_called_method.pop_arm_if_half(arm)
	hand_still_attach = false
