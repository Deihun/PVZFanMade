extends Node2D

signal ice_it
signal destroy

func _spawn() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("spawn")

func _trigger_iceberg()-> void:
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation in ["triggering"]: return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("triggering")

func  _ice_it()-> void:
	ice_it.emit()

func _destroy()-> void:
	destroy.emit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "spawn": $AnimationPlayer.play("idle")
