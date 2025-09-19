extends CharacterBody2D

var normal_speed_running := 1.0

func _ready() -> void:
	set_process(false)

func spawn_smoke_through_time():
	var smoke := preload("res://Resource/lawn_mower/smoke_effects/smoke_effect.tscn").instantiate()
	get_tree().current_scene.add_child(smoke)
	smoke.global_position = global_position - Vector2(0,50)
	

func spawn_smoke_when_zombie_hit():
	pass

func run_lawnmower():
	if $lawnmower_player.current_animation == "running":return
	$Lawnmower.play()
	$lawnmower_player.play("running")
	set_process(true)
	await get_tree().create_timer(20.0).timeout
	queue_free()

func _process(delta: float) -> void:
	position.x += (delta*500)*normal_speed_running


func _on_lawnmower_killer_body_entered(body: Node2D) -> void:
	normal_speed_running= 0.5
	if body.is_in_group("zombie") and not body.is_in_group("testing") and not body.is_in_group("ignore"):
		body.add_to_group("ignore")
		var hp = body.get_node("zombie_hp_management")
		var lawning_effect = preload("res://Resource/lawn_mower/lawnmower_assets/zombie_getting_killed_effect.tscn").instantiate()
		get_tree().current_scene.remove_child(body)
		lawning_effect.add_child(body)
		body.position = Vector2.ZERO
		add_child(lawning_effect)
		lawning_effect.global_position = self.global_position + Vector2(30,10)
		
		await get_tree().create_timer(0.6).timeout
		if hp: hp.take_damage(90000,null)
		


func _on_lawnmower_killer_body_exited(body: Node2D) -> void:
	if body.is_in_group("zombie"):
		normal_speed_running= 1.0


func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie") and not body.is_in_group("testing") and not body.is_in_group("ignore"):
		run_lawnmower()
		
