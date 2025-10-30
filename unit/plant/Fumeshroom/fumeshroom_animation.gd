extends Node2D

signal shoot_fume_1
signal shoot_fume_2
signal shoot_fume_3
signal shoot_fume_4
signal shoot_additional_fume
signal shoot_gloomshroom_fume

func _shoot_fume_1()->void:
	shoot_fume_1.emit()
func _shoot_fume_2()->void:
	shoot_fume_2.emit()
func _shoot_fume_3()->void:
	shoot_fume_3.emit()
func _shoot_fume_4()->void:
	shoot_fume_4.emit()

func _shoot_additional_fume()->void:
	shoot_additional_fume.emit()

func _shoot_gloomshroom_fume()->void:
	shoot_gloomshroom_fume.emit()
	var animation = [$Gloomshroom_overall_bod/GloomshroomBody/fumemouth_fronth/GloomshroomFumeholeEast/Design_projectile/AnimationPlayer,
	$Gloomshroom_overall_bod/GloomshroomBody/fumemouth_fronth/GloomshroomFumeholeSouth/Design_projectile/AnimationPlayer,
	$Gloomshroom_overall_bod/GloomshroomBody/fumemouth_fronth/GloomshroomFumeholeSoutheast/Design_projectile/AnimationPlayer,
	$Gloomshroom_overall_bod/GloomshroomBody/fumemouth_fronth/GloomshroomFumeholeSouthwest/Design_projectile/AnimationPlayer,
	$Gloomshroom_overall_bod/GloomshroomBody/fumemouth_fronth/GloomshroomFumeholeWest/Design_projectile/AnimationPlayer,
	$Gloomshroom_overall_bod/GloomshroomBody/behind_north_nw_ne/GloomshroomFumeholeNorth/Design_projectile/AnimationPlayer, 
	$Gloomshroom_overall_bod/GloomshroomBody/behind_north_nw_ne/GloomshroomFumeholeNortheast/Design_projectile/AnimationPlayer, 
	$Gloomshroom_overall_bod/GloomshroomBody/behind_north_nw_ne/GloomshroomFumeholeNorthwest/Design_projectile/AnimationPlayer
	]
	for a in animation:
		a.play("trigger")

func _trigger_spawn() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("fumeshroom_spawn")

func _set_to_gloomshroom() -> void: 
		$AnimationPlayer.stop()
		$AnimationPlayer.play("idle_gloomshroom")

func _attack(attackspeed_bonus: float , is_it_fumeshroom := true) -> void:
	if is_it_fumeshroom:
		if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation in ["attack_fumeshroom","fumeshroom_spawn"]: return
		$AnimationPlayer.stop()
		$AnimationPlayer.play("attack_fumeshroom")
	else:
		if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation in ["attack_gloom_shroom"]: return
		$AnimationPlayer.stop()
		$AnimationPlayer.play("attack_gloom_shroom")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["attack_fumeshroom", "idle_fumeshroom","idle_fumeshroom_2","fumeshroom_spawn"]:
		if randf_range(1.0,0.01) < 0.05:  $AnimationPlayer.play("idle_fumeshroom_2")
		else: $AnimationPlayer.play("idle_fumeshroom")
	elif anim_name in ["attack_gloom_shroom","idle_gloomshroom","idle_gloomshroom_2"]:
		if randf_range(1.0,0.01) < 0.05:  $AnimationPlayer.play("idle_gloomshroom_2")
		else: $AnimationPlayer.play("idle_gloomshroom")
