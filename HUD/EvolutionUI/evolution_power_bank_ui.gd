extends Control

func _ready() -> void:
	if !QuickDataManagement.savemanager.tool_exist("powerbank"): queue_free()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		QuickDataManagement._remove_plant_for_queue_plant(true)
		if QuickDataManagement.evolution_power_point <=0:return
		var shovel := Sprite2D.new()
		shovel.texture = load("res://HUD/EvolutionUI/evolve_power_boost.png")
		shovel.name = "power"
		shovel.z_index = 200 
		QuickDataManagement._add_object_for_queue(shovel,self)
		shovel.name = "power"
		QuickDataManagement.sound_manager.play_high_priority_audio(load("res://HUD/EvolutionUI/power_selected.ogg"))
		

func selected_as_object(_is_selected:=false):
	$EvolutionPowerBank_UI. selected_as_object(_is_selected)
