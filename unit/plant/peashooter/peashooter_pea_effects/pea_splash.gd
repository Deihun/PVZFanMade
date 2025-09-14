extends Node2D

func _ready() -> void:
	$AudioStreamPlayer.stream=get_random_audio_sound()
	$AudioStreamPlayer.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	await get_tree().create_timer(1.0).timeout
	queue_free()

func get_random_audio_sound()-> AudioStream:
	var audio:AudioStream
	match randi_range(1,3):
		1: audio = load("res://unit/plant/peashooter/peashooter_pea_effects/pea_sfx_1.mp3")
		2: audio = load("res://unit/plant/peashooter/peashooter_pea_effects/pea_sfx_2.mp3")
		3: audio = load("res://unit/plant/peashooter/peashooter_pea_effects/pea_sfx_3.mp3")
	return audio
