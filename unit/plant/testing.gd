extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("testing"):return
	if !body.is_in_group("zombie"):return
	print("detecting zombie????")
	var sprite : Sprite2D = body.get_node("final_render")
	var tween:Tween = create_tween()
	if sprite.material is ShaderMaterial:
		var shader_mat: ShaderMaterial = sprite.material

		tween.tween_property(
			sprite.material,
			"shader_parameter/affected_float",
			0.85,  # target value
			 1.0  # duration
		)



func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("testing"):return
	var sprite : Sprite2D = body.get_node("final_render")
	var tween:Tween = create_tween()
	tween.tween_property(
			sprite.material,
			"shader_parameter/affected_float",
			1.0,  # target value
			 0.3   # duration
	)
