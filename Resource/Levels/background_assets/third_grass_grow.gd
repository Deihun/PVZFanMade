extends Node2D

func _ready() -> void:
	$Control.hide()
	$grass_roll.hide()
	$grass_roll2.hide()
	$Control.position = Vector2(-1520.0,-166.0)


func _trigger_start():
	$Control.show()
	$grass_roll.show()
	$grass_roll2.show()
	$start_single_laneroll.play("play")
	$grass_roll._roll_play()
	$grass_roll2._roll_play()
