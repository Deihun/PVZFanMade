extends Node2D

signal attack

func _attack()-> void:
	attack.emit()

func play_attack(attackspeed : float = 0.0)-> void:
	if $AnimationPlayer.current_animation in ["attack_animation"]: return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("attack_animation")



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if randf_range(0.001,1.0) < 0.05: $AnimationPlayer.play("idle_2")
	else: $AnimationPlayer.play("idle")
