extends Panel

@onready var debug_tool_catcher :Node2D = $"../../BasicZombie"

func _on_debug_visibility_value_changed(value: float) -> void:
	value *= 0.01
	self_modulate.a = value
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ALT: visible = !visible
func _on_background_visibility_toggled(toggled_on: bool) -> void:
	$"../../Day".visible = toggled_on


func _on_projectile_selection_item_selected(index: int) -> void:
	match index:
		0: $"../../BasicZombie".selected_projectile = "res://unit/plant/peashooter/pea.tscn"
		1: $"../../BasicZombie".selected_projectile = "res://unit/plant/SnowPea/Snowpea_Projectile.tscn"
func _on_reset_save_data_pressed() -> void:
	QuickDataManagement.savemanager._reset_save()


func _on_hud_hide_toggled(toggled_on: bool) -> void:
	for child in $"..".get_children():
		if child == self:continue
		if child is Node2D or child is Control: child.visible = !toggled_on
	$"../../BasicZombie".visible = !toggled_on
