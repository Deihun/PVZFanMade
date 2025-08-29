extends Node2D

var value_requirement := 10.0
var already_trigger := false
var lane_rigidbody_collision

func check_if_can_trigger(value: float)-> bool:
	if already_trigger: return false
	if value >= value_requirement:
		already_trigger = true
		$Timer.start()
		return true
	return false
	


func _on_timer_timeout() -> void:
	$Flag_animation.play("trigger_wave")
