extends Node

var _health_threshold_conditions : Array = []




	# Sort based on your priority rules
	# 1. Highest priority_number first
	# 2. If same priority, highest threshold first
	# 3. If still same, last added wins (append order already ensures this)
	


func _sort_health_conditions(a: Dictionary, b: Dictionary) -> bool:
	if a["priority"] != b["priority"]:
		return a["priority"] > b["priority"]  # Higher priority first
	elif a["threshold_percent"] != b["threshold_percent"]:
		return a["threshold_percent"] > b["threshold_percent"] # Higher threshold first
	else:
		return false  # Keep insertion order


func _check_health_conditions() -> void:
	var parent = get_parent()
	for condition in _health_threshold_conditions:
		var threshold_value = parent.max_health * (condition["threshold_percent"] / 100.0)

		if parent.current_health <= threshold_value:
			if condition["trigger_once"] and condition["triggered"]:
				continue
			if condition["callable"].is_valid():
				condition["callable"].call()
				condition["triggered"] = true
