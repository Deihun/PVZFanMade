extends Control

var _evolution_array : Array[Control]
var _current_active

func _ready() -> void:
	var testing = load("res://HUD/EvolutionUI/EvolutionBoarder.tscn").instantiate()
	set_current_evolution_details([testing])

func set_current_evolution_details(evolution_array : Array[Control])-> void:
	clear_all_within_control() 
	
	for control in evolution_array:
		add_child(control)
		_evolution_array.append(control)
		control.position = Vector2.ZERO
		control.hide()
	print("evolutionSize:",evolution_array,"\n_EvolutionSize:",_evolution_array)
	_evolution_array.pop_front().show()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_mouse_pos = get_local_mouse_position()
		if not Rect2(Vector2.ZERO, size).has_point(local_mouse_pos):
			queue_free()
			clear_all_within_control()


func clear_all_within_control():
	for control in _evolution_array:
		control.queue_free()
		remove_child(control)
	if _current_active: _current_active.queue_free()
	_current_active = null
