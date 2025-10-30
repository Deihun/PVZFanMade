extends Node2D

func _ready() -> void:
	QuickDataManagement.global_calls_manager._when_plant_boost_value_change.connect(
		func(value_change_into:int): update_my_ui(value_change_into))


func update_my_ui(value:int):
	match value:
		0: $state_change.play("empty")
		1: $state_change.play("1_power")
		2: $state_change.play("2_power")
		3: $state_change.play("3_power")
		4: $state_change.play("full")
		_:$state_change.play("full")

func selected_as_object(_is_visible := false):
	$Polygon2D.visible=_is_visible
