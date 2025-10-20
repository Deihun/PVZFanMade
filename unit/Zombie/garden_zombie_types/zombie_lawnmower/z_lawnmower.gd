extends CharacterBody2D

var normal_speed_running := 1.0
var run := true

func _ready() -> void:
	add_to_group("killer_lawnmower")

func _process(delta: float) -> void:
	if run: position.x -= (delta*720)*normal_speed_running

func _on_lawnmower_killer_body_entered(body: Node2D) -> void:
	if body == self: return
	normal_speed_running = 0.5
	$getting_speedup.stop()
	$getting_speedup.start()
	if body.is_in_group("player_spawn_checker") or body.is_in_group("testing"): return
	body.add_to_group("ignore")
	var lawning_effect = preload("res://unit/Zombie/garden_zombie_types/zombie_lawnmower/z_lawn_mower_killed_animation.tscn").instantiate()
	get_tree().current_scene.remove_child(body)
	lawning_effect.add_child(body)
	body.position = Vector2.ZERO
	add_child(lawning_effect)
	lawning_effect.global_position = self.global_position + Vector2(30,10)



func _on_getting_speedup_timeout() -> void:
	normal_speed_running = 1.0


func _on_on_run_animation_finished(anim_name: StringName) -> void:
	if anim_name == "stop_":queue_free()


func _on_encounter_anotherlawnmower_body_entered(body: Node2D) -> void:
	run =false
	$on_run.stop()
	$on_run.play("stop_")
