extends Node2D

func _ready() -> void:
	QuickDataManagement.sound_manager.play_music(null)

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://Resource/Levels/Tutorial_Part/level_1_tutorial_day_1.tscn")
