extends Node2D

var upgrades = []
func _ready() -> void:
	upgrades = [
		$HBoxContainer/upgrade_1,
		$HBoxContainer/upgrade_2,
		$HBoxContainer/upgrade_3,
	]

func set_description_base_on_given_array(value: Array[String]) -> void:
	if value.is_empty():return
	for i in range(min(value.size(), upgrades.size())):
		var selected_node = upgrades[i]
		selected_node.show()
		selected_node.get_node("Label").text = value[i]
