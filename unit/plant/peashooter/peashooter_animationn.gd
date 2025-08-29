extends Node2D
var trigger_attack_method : Callable
var attack_animation_speed : float =  0.0

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
	$attack_speed_effect/attackspeed_effect.speed_scale = 1.0+attack_animation_speed
	$attack_speed_effect/attackspeed_effect.stop()
	$attack_speed_effect/attackspeed_effect.play("trigger")


func start_attacking():
	$AnimationPlayer.stop()
	$AnimationPlayer.speed_scale =  1.0 + attack_animation_speed + randf_range(0.2,0)
	$AnimationPlayer.play("shooting_animation")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shooting_animation" or anim_name == "spawn":
		$AnimationPlayer.speed_scale = randf_range(0.8,1)
		$AnimationPlayer.play("idle")


func _tier2A():
	$Panel/StemVinesTier2aUpgrade.show()
func _tier2B():
	$attack_speed_effect.show()
