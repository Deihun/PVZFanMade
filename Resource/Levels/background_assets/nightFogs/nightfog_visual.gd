extends Node2D
var about_to_disappear := false
var randoms :Array[String] =[
		"res://Resource/Levels/background_assets/nightFogs/1.png",
		"res://Resource/Levels/background_assets/nightFogs/2.png",
		"res://Resource/Levels/background_assets/nightFogs/3.png",
		"res://Resource/Levels/background_assets/nightFogs/4.png",
		"res://Resource/Levels/background_assets/nightFogs/5.png",
		"res://Resource/Levels/background_assets/nightFogs/6.png",
		"res://Resource/Levels/background_assets/nightFogs/7.png",
		"res://Resource/Levels/background_assets/nightFogs/8.png"
]

func _ready() -> void:
	pick_random_texture()
	await get_tree().create_timer(randf_range(0.5,1.0)).timeout
	$zmog_animation.play("entering")

func pick_random_texture()-> void:
	$Sprite2D_1.texture= load(get_new_texture_of_fog())
	$Sprite2D_2.texture= load(get_new_texture_of_fog())

func got_litted()->void:
	about_to_disappear = true
	$zmog_animation.play("disappearing")

func get_new_texture_of_fog()-> String:
	randoms.shuffle()
	return randoms.pop_back()


func _on_zmog_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "entering": $zmog_animation.play("idle")
	if anim_name=="disappearing": queue_free()
