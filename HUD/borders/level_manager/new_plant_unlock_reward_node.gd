extends Node2D


@export_category("DETAILS ON THIS REWARD")
@export_multiline var _reward_description : String
@export_file("*.tscn") var _next_scene_to_play
@export var level_data_name : String
@export_category("PLANTS UNLOCK")
@export var _plant_name : String
@export var _unlock_plant_tier_1 := false
@export var _unlock_plant_tier_2 := false
@export var _unlock_plant_tier_3 := false
@export_category("TOOLS UNLOCK")
@export var _tool_name : String
@export var _upgrade_on_that_tool_name : Array[String]

var _already_happen := false
var _method_when_confirm_click : Callable 
var _call_this_when_collecting_reward_ArrayCallable:  Array[Callable] =[]

func unlock_something() -> void:
	if !_plant_name.is_empty() or _plant_name:
		QuickDataManagement.savemanager.unlock_new_plant(_plant_name.to_lower())
		if _unlock_plant_tier_1: QuickDataManagement.savemanager.unlock_tier(_plant_name,"tier1")
		if _unlock_plant_tier_2: QuickDataManagement.savemanager.unlock_tier(_plant_name,"tier2")
		if _unlock_plant_tier_3: QuickDataManagement.savemanager.unlock_tier(_plant_name,"tier3")
	if !_tool_name.is_empty() or _tool_name:
		QuickDataManagement.savemanager.unlock_new_tools(_tool_name)
		if _upgrade_on_that_tool_name.size() > 0:
			for _tool_upgrade in _upgrade_on_that_tool_name:
				QuickDataManagement.savemanager.unlock_upgrade_on_tools(_tool_name,_tool_upgrade)
	if !level_data_name.is_empty() or level_data_name:
		QuickDataManagement.savemanager.complete_level(level_data_name)






func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !_already_happen:
		_already_happen = true
		var _child
		for child in get_children():
			if child is Node2D and child not in [$Node2D,$Node2D/Panel,$Node2D/shine_ray_1,$Node2D/WhiteShineReward1,$Camera2D,$next_day, $next_day/NinePatchRect, $next_day/NinePatchRect/Label, $next_day/NinePatchRect/Label/Button,$Panel]:
				if child is Sprite2D:
					_child = child
				else: child.z_index = 150
			$next_day/NinePatchRect/Label.text = _reward_description
		
		$AnimationPlayer.play("_zoom_and_transfer")
		await get_tree().create_timer(5.25).timeout
		$next_day/NinePatchRect/unlocked_plant_placement.texture =_child.texture
		unlock_something()
		for call in _call_this_when_collecting_reward_ArrayCallable:
			if call.is_valid():call.call()
			else: _call_this_when_collecting_reward_ArrayCallable.erase(call)
		$Camera2D.make_current()



func _on_button_pressed() -> void:
	if _method_when_confirm_click.is_valid(): _method_when_confirm_click.call()
	get_tree().change_scene_to_file(_next_scene_to_play)

#
#func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !already_happen:
		#_on_button_pressed()	
