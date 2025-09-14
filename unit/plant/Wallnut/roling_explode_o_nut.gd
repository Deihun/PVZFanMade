extends CharacterBody2D
@export var speed: float = 200.0

func _ready() -> void:
	QuickDataManagement.sound_manager.play_sound_SFX(load("res://unit/plant/Wallnut/wallnut_rolling_bowling.mp3"))
	add_to_group("plant")
	$warning_zone.add_to_group("plant")
	set_collision_layer_value(1,true)
	$Wallnut.set_explode_rolling_wallnut()
	velocity = Vector2.RIGHT * speed

func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)


func _on_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie"):
		queue_free()
		var explosion :Node2D= load("res://unit/plant/CherryBomb/cherry_bomb_explosion_animation.tscn").instantiate()
		get_tree().current_scene.add_child(explosion)
		explosion.global_position = global_position
		QuickDataManagement.sound_manager.play_sound_SFX(load("res://unit/plant/Wallnut/explode_o_nut_hit.mp3"))
		explosion.explode()
