@tool
extends Node2D

func _process(delta: float) -> void:
	$Label.visible = get_parent()._mark_as_big_wave
