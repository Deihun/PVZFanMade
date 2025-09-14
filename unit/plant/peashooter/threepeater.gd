extends Node2D
var trigger_attack_method : Callable
var attack_animation_speed : float =  0.0

func _trigger_attack() -> void:
	if trigger_attack_method.is_valid(): 
		trigger_attack_method.call()


func start_attacking():
	print("animation debug")
	$AnimationPlayer.stop()
	$AnimationPlayer.speed_scale =  max(min(1.0+attack_animation_speed,4.0),1.0) + randf_range(0.2,0)
	$AnimationPlayer.play("attack")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		$AnimationPlayer.speed_scale = randf_range(0.8,1)
		$AnimationPlayer.play("idle")
