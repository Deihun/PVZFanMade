extends Area2D

var i_detect_plants : Callable
var detected_plant : Node2D
var _detected_plants : Array[Node2D] = []


func _on_body_entered(body: Node2D) -> void:
	_detected_plants.append(body)
	if i_detect_plants.is_valid():i_detect_plants.call()


func _on_body_exited(body: Node2D) -> void:
	if body in _detected_plants:
		_detected_plants.erase(body)
		if i_detect_plants.is_valid():i_detect_plants.call()

func get_target_plant() -> Node2D:
	if _detected_plants.size() > 0: return _detected_plants.back()
	else: return detected_plant
