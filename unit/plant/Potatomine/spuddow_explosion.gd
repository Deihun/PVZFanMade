extends Node2D
var delay := 0.001
var damage := 2000
var master 

func _ready() -> void:
	$Area2D/CollisionShape2D.disabled = true
	$".".hide()
	$Timer.wait_time = delay
	$Timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie"):
		var max_hp = body.get_node("zombie_hp_management")
		if max_hp: max_hp.take_damage(damage,master)


func _on_timer_timeout() -> void:
	QuickDataManagement.sound_manager.play_explosion_sound_SFX(load("res://unit/plant/Potatomine/SFX potato mine.mp3"))
	$AnimationPlayer.play("explosion")
