extends Node2D

func add_object_inside_label(node : Node) ->void:
	$image.add_child(node)

func set_for_image_instead(image : String)-> void:
	$Label.hide()
	$image.texture = load(image)
func set_text(value : String)-> void:
	$Label.text = value
func set_color_as_damage_indication()-> void:
	$Label.add_theme_color_override("font_color", Color("#ffb65b"))

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
