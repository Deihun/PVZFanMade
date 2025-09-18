extends Node2D

func _ready() -> void:
	scale = Vector2(randf_range(0.75,1.0),randf_range(0.75,1.0))
	for node in [$"1",$"2",$"3"]:
		node.rotation = randf_range(0.0,360.0)
		node.modulate.a = randf_range(0.5,1.0)
	$AnimationPlayer.play("new_animation")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()

func _process(delta: float) -> void:
	position.x += delta*50
