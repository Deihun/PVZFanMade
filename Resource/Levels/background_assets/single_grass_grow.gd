extends Node2D

func _ready() -> void:
	self.hide()
	$Control.position = Vector2(-1520.0,-166.0)


func _trigger_start():
	self.show()
	$start_single_laneroll.play("play")
	$grass_roll._roll_play()
