extends Node2D

var value_requirement := 10.0
var already_trigger := false
var lane_rigidbody_collision

func trigger_animation()-> void:
	$Flag_animation.play("trigger_wave")
