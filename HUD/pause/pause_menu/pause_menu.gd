extends Control
var time_scale_before : float

func _ready() -> void:
	time_scale_before = Engine.time_scale
	Engine.time_scale = 0.0
func _on_tree_exited() -> void:
	Engine.time_scale = time_scale_before


func _on_resume_mouse_entered() -> void:
	$PauseBoarder/Resume/PauseResumeButtonHover.show()
	$PauseBoarder/Resume/PauseResumeButtonUnhover.hide()
func _on_resume_mouse_exited() -> void:
	$PauseBoarder/Resume/PauseResumeButtonHover.hide()
	$PauseBoarder/Resume/PauseResumeButtonUnhover.show()
func _on_resume_click() -> void:
	queue_free()


func _on_main_menu_mouse_entered() -> void:
	$PauseBoarder/MAIN_MENU/PauseMainmenuButtonHover.show()
	$PauseBoarder/MAIN_MENU/PauseMainmenuButtonUnhover.hide()
func _on_main_menu_mouse_exited() -> void:
	$PauseBoarder/MAIN_MENU/PauseMainmenuButtonHover.hide()
	$PauseBoarder/MAIN_MENU/PauseMainmenuButtonUnhover.show()
func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://HUD/main_menu/main_menu.tscn")


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
func _on_restart_mouse_entered() -> void:
	$PauseBoarder/RESTART/PauseMainmenuButtonHover.show()
	$PauseBoarder/RESTART/PauseMainmenuButtonUnhover.hide()
func _on_restart_mouse_exited() -> void:
	$PauseBoarder/RESTART/PauseMainmenuButtonHover.hide()
	$PauseBoarder/RESTART/PauseMainmenuButtonUnhover.show()
