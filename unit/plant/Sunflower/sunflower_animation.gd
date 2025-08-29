extends Node2D
var producing_sun_callable : Callable
var twin_sunflower_:bool=false

func _produce_sun_by_animation_trigger():
	if producing_sun_callable.is_valid(): producing_sun_callable.call()

func spawn():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("spawn")

func golden_sunflower():
	$Sunflower_head/face/SunflowerFaceUnlit.texture =load("res://unit/plant/Sunflower/golden_sunflower_face_unlit.png")
	$Sunflower_head/face/SunflowerFaceLit.texture =load("res://unit/plant/Sunflower/golden_sunflower_face_lit.png")
	$NormalPeashooterFootBack.self_modulate = Color("#c64e00")
	$NormalPeashooterFootFront.self_modulate = Color("#c64e00")
	for sprite in $Sunflower_head/petals.get_children():
		if sprite is Sprite2D: sprite.texture=load("res://unit/plant/Sunflower/goldensunflower_petal.png")

func _play_twin_sunflower():
	twin_sunflower_ = true
	$AnimationPlayer.play("twin_sunflower_idle")



func release_sun():
	$AnimationPlayer.stop()
	if twin_sunflower_: $AnimationPlayer.play("twin_sunflower_releasing_sun")
	else: $AnimationPlayer.play("sun_release")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if twin_sunflower_:
		if anim_name == "twin_sunflower_releasing_sun" or anim_name == "twin_sunflower_idle":
			$AnimationPlayer.play("twin_sunflower_idle")
			return
	if anim_name == "spawn" or anim_name == "sun_release":
		$AnimationPlayer.play("idle")
