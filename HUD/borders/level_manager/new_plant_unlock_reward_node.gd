extends Node2D

@export_enum("Unlock-Plant","Unlock-Tier","Unlock-Upgrades") 
var mode_of_choices : String
var method_when_confirm_click : Callable 
var already_happen := false
@export_multiline var reward_description : String
@export var plant_name : String
@export var plant_tier_target : String
@export var upgrade_target : String
@export var upgrade_tier_target : String
@export_file("*.tscn") var next_scene_to_play


func unlock_plant() -> void:
	match mode_of_choices:
		"Unlock-Plant":
			QuickDataManagement.savemanager.unlock_new_plant(plant_name)
		"Unlock-Tier":
			
			pass
		"Unlock-Upgrades":
			QuickDataManagement.savemanager.unlock_new_tools(upgrade_target)
			pass



func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !already_happen:
		already_happen = true
		var _child
		for child in get_children():
			if child is Node2D and child not in [$Node2D,$Node2D/Panel,$Node2D/shine_ray_1,$Node2D/WhiteShineReward1,$Camera2D,$next_day, $next_day/NinePatchRect, $next_day/NinePatchRect/Label, $next_day/NinePatchRect/Label/Button,$Panel]:
				if child is Sprite2D:
					_child = child
				else: child.z_index = 150
			$next_day/NinePatchRect/Label.text = reward_description
		
		$AnimationPlayer.play("_zoom_and_transfer")
		await get_tree().create_timer(5.25).timeout
		$next_day/NinePatchRect/unlocked_plant_placement.texture =_child.texture
		unlock_plant()
		
		$Camera2D.make_current()



func _on_button_pressed() -> void:
	if method_when_confirm_click.is_valid(): method_when_confirm_click.call()
	get_tree().change_scene_to_file(next_scene_to_play)

#
#func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !already_happen:
		#_on_button_pressed()	
