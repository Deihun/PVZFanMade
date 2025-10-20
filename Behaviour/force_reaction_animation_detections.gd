extends Area2D

@export var group_filters : Array[String] 

@export var detect_char_body_2d := true
@export var detect_area_2d := true

signal reaction_is_trigger


func _on_area_entered(area: Area2D) -> void:
	if detect_area_2d and contains_all(area.get_groups(),group_filters):
		reaction_is_trigger.emit()

func _on_body_entered(body: Node2D) -> void:
	if detect_char_body_2d and contains_all(body.get_groups(),group_filters):
		reaction_is_trigger.emit()


func contains_all(first_array: Array, second_array: Array) -> bool:
	for item in second_array:
		if item not in first_array:
			return false
	return true
