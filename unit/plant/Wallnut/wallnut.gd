extends Node2D
var _is_tall_nut_set := false

func set_shield_visible(visible_ : bool):
	$Shield.visible = visible_

func set_normal_rolling_wallnut():
	$AnimationPlayer.play("rolling_wallnut")

func set_explode_rolling_wallnut():
	$AnimationPlayer.play("rolling_wallnut")
	

func set_to_tallnutt():
	_is_tall_nut_set = true
	$animationn.stop()
	$AnimationPlayer.stop()
	$AnimationPlayer.play("tallnut_idle_full")

func _trigger_fullhealth_animation():
	if _is_tall_nut_set:
		$animationn.stop()
		$AnimationPlayer.stop()
		$AnimationPlayer.play("tallnut_idle_full")
		$tall_nut/TallNutFull.texture = load("res://unit/plant/Wallnut/tall_nut_full.png")
		return
	$AnimationPlayer.stop()
	$animationn.stop()
	$AnimationPlayer.stop()
	$animationn.play("full_idle")
	$AnimationPlayer.play(("idle_full"))
	$WallnutBody.texture = load("res://unit/plant/Wallnut/wallnut_body.png")

func _trigger_damage_animation():
	if _is_tall_nut_set:
		$animationn.stop()
		$AnimationPlayer.stop()
		$AnimationPlayer.play("tallnut_idle_full")
		$tall_nut/TallNutFull.texture = load("res://unit/plant/Wallnut/tall_nut_damage.png")
		return
	$animationn.stop()
	$AnimationPlayer.stop()
	$animationn.play("damage_idle")
	$AnimationPlayer.play(("idle_full"))
	$WallnutBody.texture = load("res://unit/plant/Wallnut/wallnut_body_damage.png")
	

func _trigger_lethal_animation():
	if _is_tall_nut_set:
		$animationn.stop()
		$AnimationPlayer.stop()
		$AnimationPlayer.play("tallnut_idle_full")
		$tall_nut/TallNutFull.texture = load("res://unit/plant/Wallnut/tall_nut_lethal.png")
		return
	$animationn.stop()
	$AnimationPlayer.stop()
	$animationn.play("lethal_idle")
	$AnimationPlayer.play(("idle_full"))
	$WallnutBody.texture = load("res://unit/plant/Wallnut/wallnut_body_lethal.png")

func _spawn():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("spawn")

func _on_animationn_animation_finished(anim_name: StringName) -> void:
	if anim_name == "spawn":
		_trigger_fullhealth_animation()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "spawn":
		_trigger_fullhealth_animation()
	elif anim_name == "tallnut_idle_full_2" or anim_name == "tallnut_idle_full" or anim_name == "tallnut_idle rare":
		var random := randf_range(0.0,1.0)
		if random <0.51:
			$AnimationPlayer.play("tallnut_idle_full")
		elif random >0.01 and random < 0.51:
			$AnimationPlayer.play("tallnut_idle_full_2")
		else:
			$AnimationPlayer.play("tallnut_idle_full rare")
