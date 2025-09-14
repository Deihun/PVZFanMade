extends Node2D
var _already_trigger_death:=false
var _already_half := false
var _run_callable : Callable
var _walk_callable : Callable
var _eat_callable : Callable
var _can_be_stop_callable : Callable
var _change_hitbox_callable : Callable
var _vaulting_callable : Callable

func get_animation_player()->AnimationPlayer:
	return $AnimationPlayer

func _run_trigger():
	if _run_callable.is_valid():_run_callable.call()

func _change_hitbox_trigger():
	if _change_hitbox_callable.is_valid():_change_hitbox_callable.call()

func _walk_trigger():
	if _walk_callable.is_valid():_walk_callable.call()

func _eat_trigger():
	if _eat_callable.is_valid():_eat_callable.call()

func _can_be_stop_trigger():
	if _can_be_stop_callable.is_valid():_can_be_stop_callable.call()

func _vault_trigger():
	if _vaulting_callable.is_valid():_vaulting_callable.call()

func set_idle_animation():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("idle")

func walk_animation():
	if $AnimationPlayer.current_animation == "vaulting": return
	if $AnimationPlayer.current_animation == "death_while_running" or _already_trigger_death:return
	if $AnimationPlayer.current_animation == "walking_animation":return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("walking_animation")

func run_animation():
	if $AnimationPlayer.current_animation == "death_while_running" or _already_trigger_death:return
	if $AnimationPlayer.current_animation == "running_with_pole":return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("running_with_pole")

func vault_animation():
	if $AnimationPlayer.current_animation == "death_while_running" or _already_trigger_death:return
	if $AnimationPlayer.current_animation == "vaulting":return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("vaulting")

func _eating_animation():
	if $AnimationPlayer.current_animation == "vaulting":return
	if $AnimationPlayer.current_animation == "death_while_running" or _already_trigger_death:return
	if $AnimationPlayer.current_animation == "eating_animation":return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("eating_animation")

func _death_animation():
	if _already_trigger_death:return
	_already_trigger_death=true
	$AnimationPlayer.stop()
	$AnimationPlayer.play("death_while_running")
	var head_node =$main_control/PoleVaultZombieMainBody/head
	QuickDataManagement.common_called_method.popup_zombie_head_animation(self,head_node)


func _remove_arm():
	if _already_half: return
	_already_half = true
	var _target_arm := $main_control/PoleVaultZombieMainBody/PoleVaultZombieShoulderRight/PoleVaultZombieForearmRight
	QuickDataManagement.common_called_method.pop_arm_if_half(_target_arm)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="vaulting":$AnimationPlayer.play("walking_animation")
