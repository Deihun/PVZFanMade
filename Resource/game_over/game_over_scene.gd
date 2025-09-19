extends Node2D

func _ready() -> void:
	QuickDataManagement.sound_manager.play_music(load("res://Resource/Levels/Tutorial_Part/Modern_Day_Defeat.ogg"),false)


func _on_retry_btn_pressed() -> void:
	get_tree().reload_current_scene()
