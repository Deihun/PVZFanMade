extends CharacterBody2D

@export var speed: float = 200.0
var can_hit_again := true
var direction_value := 0

func _ready() -> void:
	QuickDataManagement.sound_manager.play_sound_SFX(load("res://unit/plant/Wallnut/wallnut_rolling_bowling.mp3"))
	$Wallnut.set_normal_rolling_wallnut()
	velocity = Vector2.RIGHT * speed

func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)

	var collision = get_last_slide_collision()
	if collision:
		_handle_collision(collision)

func _handle_collision(collision: KinematicCollision2D) -> void:
	var collider = collision.get_collider()
	if collider == null:
		return


	if collider.is_in_group("zombie"):
		if randf() < 0.5:
			velocity = Vector2(speed, -speed)
		else:
			velocity = Vector2(speed, speed)  

	elif collider.is_in_group("edgeup"):
		velocity = Vector2(speed, speed)
	elif collider.is_in_group("edgedown"):
		velocity = Vector2(speed, -speed)


func _on_trigger_body_entered(body: Node2D) -> void:
	_bounce_when_hit()
	if can_hit_again:
		var get_hp_node = body.get_node("zombie_hp_management")
		$cooldown_hit.start()
		can_hit_again =false
		if !get_hp_node:return
		get_hp_node.take_damage(450,self)
		QuickDataManagement.sound_manager.play_sound_SFX(load("res://unit/plant/Wallnut/normal_wallnut_hit.mp3"))
	

func _bounce_when_hit():
	if direction_value == 0 : direction_value = randi_range(1,2)
	elif direction_value == 1: direction_value = 2
	elif direction_value == 2: direction_value = 1
	match direction_value:
		0:
			velocity = Vector2.RIGHT * speed
		1:
			velocity = Vector2(speed, -speed)
		2: 
			velocity = Vector2(speed, speed)
	


func _on_timer_timeout() -> void:
	queue_free()


func _on_cooldown_hit_timeout() -> void:
	can_hit_again = true

func _on_trigger_area_entered(area: Area2D) -> void:
	_bounce_when_hit()
