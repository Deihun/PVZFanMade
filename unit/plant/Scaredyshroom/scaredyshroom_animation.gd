extends Node2D
signal shoot
var is_hiding : bool = false
var empower := 0

func _emit_shoot()-> void:
	shoot.emit()

func _emit_shoot_with_empower()->  void:
	shoot.emit()
	empower -= 1
func _emit_trigger_empower_attack()-> void:
	empower += 1
	$AnimationPlayer.stop()
	$AnimationPlayer.play("attack_empower")
	
func trigger_shoot(attackspeed : bool) -> void:
	if $AnimationPlayer.current_animation in ["attack","hiding_idle","trigger_hide","trigger_unhide","spawn"]: return
	is_hiding = true
	$AnimationPlayer.stop()
	$AnimationPlayer.play("attack")
func trigger_spawn()-> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("spawn")


func trigger_hide() -> void:
	if $AnimationPlayer.current_animation in ["trigger_hide","hiding_idle"]: return
	is_hiding = true
	$AnimationPlayer.stop()
	$AnimationPlayer.play("trigger_hide")
func trigger_unhide() -> void:
	is_hiding = false
	$AnimationPlayer.stop()
	$AnimationPlayer.play("trigger_unhide")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if empower > 0:
		$AnimationPlayer.stop()
		$AnimationPlayer.play("attack_empower")
	elif anim_name in ["trigger_hide","hiding_idle"]:
		$AnimationPlayer.play("hiding_idle")
	elif anim_name in ["attack_empower","attack","trigger_unhide","idle","idle_2","spawn"]:
		if randf_range(0.1,1.0) < 0.2: $AnimationPlayer.play("idle_2")
		else: $AnimationPlayer.play("idle")
