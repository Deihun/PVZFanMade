extends Node2D

signal produce_sun

var amount_of_times_to_produce_sun := 0

func _call_to_produce_sun()-> void:
	produce_sun.emit()

func trigger_to_produce_sun()-> void:
	amount_of_times_to_produce_sun +=1

func _trigger_spawn() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("spawn")

func grow_to_second_phase() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("grow_to_2_stage")

func grow_to_last_phase() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("grow_to_2_stage_3")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if amount_of_times_to_produce_sun > 0: 
		$AnimationPlayer.play("Producing_sun")
		amount_of_times_to_produce_sun -=1
	else:
		if randf_range(0.1,1.0) < 0.05: $AnimationPlayer.play("idle_2")
		else: $AnimationPlayer.play("idle")
