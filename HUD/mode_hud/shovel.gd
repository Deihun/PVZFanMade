extends Control

func _ready() -> void:
	if !QuickDataManagement.savemanager.tool_exist("shovel"): queue_free()
	add_to_group("shovel")
	$clickable_area.add_to_group("shovel")


func _on_clickable_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		QuickDataManagement._remove_plant_for_queue_plant(true)

		var shovel := Sprite2D.new()
		shovel.texture = load("res://HUD/mode_hud/shovel.png")
		shovel.name = "shovel_icon"
		shovel.z_index = 200

		QuickDataManagement._add_object_for_queue(shovel)
		shovel.name = "shovel_icon"
