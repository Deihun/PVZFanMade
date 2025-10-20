extends Node2D

var _shoot_snow_call : Callable

func _trigger_shoot_snow() -> void:
	if _shoot_snow_call.is_valid(): _shoot_snow_call.call()

func trigger_shoot(bonus_attackspeed: float =0.0) -> void: 
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation in ["shoot","spawn","when_creating_iceberg"]:return
	$AnimationPlayer.speed_scale = min((1.0 + (bonus_attackspeed)),  8.0)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("shoot")

func spawn() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("spawn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["spawn", "shoot", "idle_animation","when_creating_iceberg"]: $AnimationPlayer.play("idle_animation")

func _t1a()-> void:
	$snowpea_wholebody/NormalPeashooterFootFront/SnowpeaFootbehindT1a.show()
	$snowpea_wholebody/NormalPeashooterFootFront/NormalPeashooterFootBack.hide()
	$snowpea_wholebody/NormalPeashooterFootFront.texture =load("res://unit/plant/SnowPea/snowpea_foott1a.png")

func _t1b()-> void:
	$snowpea_wholebody/T1B_effect.show()

func _t2a()-> void:
	$T2A_blizzard/AnimationPlayer.play("blizard_effect")
	$T2A_blizzard.show()

func _t2b()-> void:
	$snowpea_wholebody/SnowpeaHead/SnowpeaMouth/T2b.show()

func _t3a()->void:
	$snowpea_wholebody/NormalPeashooterFootFront/Panel/extensions/StemT3a.show()
	$snowpea_wholebody/SnowpeaHead/SnowpeaTail/SnowpeaTail.show()
	$snowpea_wholebody/SnowpeaHead/SnowpeaTail/SnowpeaTail2.show()
	$snowpea_wholebody/SnowpeaHead/SnowpeaMouth.texture= load("res://unit/plant/SnowPea/t3A_mouth.png")
	

func _t3b()-> void:
	$snowpea_wholebody/SnowpeaHead.texture= load("res://unit/plant/SnowPea/t3B_snowpea.png")
	$snowpea_wholebody/SnowpeaHead/SnowpeaTail.texture = load("res://unit/plant/SnowPea/t3B_behind_snowpea.png")
	$snowpea_wholebody/NormalPeashooterFootFront/Panel/extensions/StemT3b.show()

func _t3b_iceberg_create_animation()-> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("when_creating_iceberg")
