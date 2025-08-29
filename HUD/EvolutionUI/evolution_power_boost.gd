extends Node2D
var canBecollected := true

func _on_collect_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and canBecollected:
		if QuickDataManagement.gain_evolution_power_point():
			canBecollected = false
			var a = randf_range(0.5,0.8)
			var tween = create_tween()
			tween.tween_property(self, "global_position", QuickDataManagement._evolution_bank_position, a).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			await get_tree().create_timer(a).timeout
			self.queue_free()
