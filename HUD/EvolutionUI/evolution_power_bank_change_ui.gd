extends Node2D

func _ready() -> void:
	QuickDataManagement.global_calls_manager._plant_boost_value_change.append(Callable(self,"update_my_ui"))

func update_my_ui():
	match QuickDataManagement.evolution_power_point:
		0: $state_change.play("empty")
		1: $state_change.play("1_power")
		2: $state_change.play("2_power")
		3: $state_change.play("3_power")
		4: $state_change.play("full")
		_:pass

func selected_as_object(_is_visible := false):
	$Polygon2D.visible=_is_visible
