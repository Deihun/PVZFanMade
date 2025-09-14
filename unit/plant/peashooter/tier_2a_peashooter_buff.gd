extends Node2D


func _on_play__animation_finished(anim_name: StringName) -> void:
	queue_free()
