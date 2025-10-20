extends Node2D

func _ready() -> void:
	var snow_after_hits_texture = ["res://unit/plant/SnowPea/shine_effect_1.png", "res://unit/plant/SnowPea/shine_effect_2.png"]
	$ShineEffect1.rotate(randf_range(0.0,360))
	$ShineEffect1.texture = load(snow_after_hits_texture.pick_random())


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
