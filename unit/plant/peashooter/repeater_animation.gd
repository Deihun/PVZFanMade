extends Node2D
var trigger_attack_method : Callable
var trigger_big_attack : Callable
var done_animating : Callable
var attack_animation_speed : float =  0.0

func _spawn() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("spawn")

func _trigger_attack() -> void:
	if trigger_attack_method.is_valid(): 
		trigger_attack_method.call()


func _trigger_bigshot() -> void:
	if trigger_big_attack.is_valid(): 
		trigger_big_attack.call()


func _big_shot():
	$AnimationPlayer.stop()
	$AnimationPlayer.speed_scale =  1.0 + attack_animation_speed + randf_range(0.2,0)
	$AnimationPlayer.play("big_shot")


func start_attacking():
	$AnimationPlayer.stop()
	$AnimationPlayer.speed_scale =  1.0 + attack_animation_speed + randf_range(0.2,0)
	$AnimationPlayer.play("shooting_animation")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shooting_animation" or anim_name == "spawn" or anim_name == "big_shot":
		$AnimationPlayer.speed_scale = randf_range(0.8,1)
		$AnimationPlayer.play("idle")
	if anim_name == "big_shot": done_animating.call()
