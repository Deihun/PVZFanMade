extends Node2D
var trigger_attack_method : Callable
var attack_animation_speed : float =  0.0
var first_time_attacking_again:= true

func _spawn() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("spawn")

func _tier1A():
	$NormalPeashooterHead/NormalPeashooterTail.self_modulate = Color(1.0, 0.7, 0.7)
	$NormalPeashooterFootFront.self_modulate = Color(1.0, 0.7, 0.7)

func _tier1B():
	$NormalPeashooterHead/NormalPeashooterTail.self_modulate = Color(1, 0.9, 0.4)


func _trigger_attack() -> void:
	if trigger_attack_method.is_valid(): 
		trigger_attack_method.call()
	$attack_speed_effect/attackspeed_effect.speed_scale = max(min(1.0+attack_animation_speed,4.0),0.1)
	$attack_speed_effect/attackspeed_effect.stop()
	$attack_speed_effect/attackspeed_effect.play("trigger")

func attack()-> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.speed_scale =  0.001 + max(min(1.0+attack_animation_speed,4.0),0.001) + randf_range(0.1,0.0)
	$AnimationPlayer.play("shooting_animation")

func start_attacking():
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation in ["shooting_animation","alerted","spawning"]: return
	if first_time_attacking_again:
		$AnimationPlayer.play("alerted")
		first_time_attacking_again = false
	else: attack()
	$Timer.stop()
	$Timer.start()



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shooting_animation" or anim_name == "spawn":
		$AnimationPlayer.speed_scale = randf_range(0.8,1)
		$AnimationPlayer.play("idle")
	elif anim_name == "alerted": attack()


func _tier2A():
	$Panel/StemVinesTier2aUpgrade.show()
func _tier2B():
	$attack_speed_effect.show()


func _on_timer_timeout() -> void:
	first_time_attacking_again = true
