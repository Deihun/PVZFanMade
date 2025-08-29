extends Node2D

func _ready() -> void:
	visible = false

func _roll_play():
	$trigger_rolling_grass.play("play")
