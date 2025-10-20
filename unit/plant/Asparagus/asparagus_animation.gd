extends Node2D

signal _shoot_signal
signal _special_shooted_projectile_signal

func _shoot() -> void:
	_shoot_signal.emit()

func _special_shoot() -> void:
	_special_shooted_projectile_signal.emit()

func special_shoot(bonusattackspeed : float = 0.0)-> void:
	if  $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation in ["shoot","spawn","special_shoot_attack"] : return
	$AnimationPlayer.speed_scale = min( (1.0) + bonusattackspeed
	, 8.0)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("special_shoot_attack")

func shoot(bonus_attackspeed : float =0.0)  -> void:
	if  $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation in ["shoot","spawn","special_shoot_attack"] : return
	$AnimationPlayer.speed_scale = min( (1.0) + bonus_attackspeed
	, 8.0)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("shoot")

func spawn() -> void:
	$AnimationPlayer.play("spawn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["shoot", "idle","idle_with_blink","spawn","special_shoot_attack"]:
		if randf_range(1.0,0.0) < 0.1: $AnimationPlayer.play("idle_with_blink")
		else: $AnimationPlayer.play("idle")


#------------------
# EVOLUTION UPGRADE
#------------------

func tier_1A() -> void:
	$asparagus_main_body/AsparagusMainbody/Tier1aFooting.show()

func tier_2A()->void:
	$asparagus_main_body/AsparagusMainbody/AsparagusHead/HairBehind/HairFront.texture = load("res://unit/plant/Asparagus/hair_front_tier2A.png")

func tier_2B()-> void:
	$asparagus_main_body/AsparagusMainbody/AsparagusHead/HairBehind.self_modulate.a = 0.0
	$asparagus_main_body/AsparagusMainbody/AsparagusHead/HairBehind/AsparagusHairUpgradeT2b.show()

func tier_3B()-> void:
	$asparagus_main_body/AsparagusMainbody/AsparagusHead/Mouth.texture = load("res://unit/plant/Asparagus/asparagus_t3B/tier3B_mouth.png")
