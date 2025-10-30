extends Node2D

signal puffshoot
signal death

func _set_expiration_indication(value : float = 0.0):
	$overall_puffshroom/PuffsrhoomBod/face_and_head/PuffshroomCap/ExpireIndication.self_modulate.a = value

func _trigger_shoot()-> void:
	puffshoot.emit()

func _trigger_death() -> void:
	death.emit()

func play_death() -> void:
	if $AnimationPlayer.current_animation == "death": return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("death")

func shoot(bonusAttackSpeed: float, normal_shot:= true)-> void:
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation in ["attack_animation","attack_animation_2_attacks","spawn", "death"]: return
	$AnimationPlayer.stop()
	if normal_shot: $AnimationPlayer.play("attack_animation")
	else: $AnimationPlayer.play("attack_animation_2_attacks")

func spawn()-> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("spawn")



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("idle")
