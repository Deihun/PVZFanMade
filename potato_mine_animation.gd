extends Node2D
var callable_explode : Callable

func _ready() -> void:
	$Control/PotatomineBody/PotatomineNonAlarm/PotatomineNonAlarm.hide()
	$Control/PotatomineBody/PotatomineNonAlarm/PotatomineNonAlarm2.hide()

func _tier3a():
	$Control/PotatomineBody/PotatomineNonAlarm/PotatomineNonAlarm.show()
	$Control/PotatomineBody/PotatomineNonAlarm/PotatomineNonAlarm2.show()
	$Control/PotatomineBody.self_modulate = Color("febab2")

func _tier3b():
	$Control/PotatomineBody.self_modulate = Color("#ffe457")

func _explode():
	if callable_explode.is_valid():callable_explode.call()

func play_idle():
	$AnimationPlayer.play("idle")

func explode():
	$AnimationPlayer.play("about_to_explode")

func play_idle_unarmed():
	$AnimationPlayer.play("unarmed")

func arming():
	$AnimationPlayer.play("arming")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "arming":  play_idle()
