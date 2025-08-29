extends CharacterBody2D

var hp: int = 10


func _ready() -> void:
	add_to_group("zombie")
	add_to_group("testing")

func _process(delta: float) -> void:
	position = get_global_mouse_position()
	

func _input(event):
	# Check if it's a mouse button event and it's a left click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Check if F1 is currently being held down
		if Input.is_key_pressed(KEY_F1):
			var zombie = load("res://unit/Zombie/basic_zombie/basic_zombie.tscn").instantiate()
			get_tree().current_scene.add_child(zombie)
			zombie.global_position = get_global_mouse_position()
		elif Input.is_key_pressed(KEY_F2):
			var zombie = load("res://unit/Zombie/basic_zombie/basic_zombie.tscn").instantiate()
			get_tree().current_scene.add_child(zombie)
			zombie.global_position = get_global_mouse_position()
			var zombie_hp_management = zombie.get_node("zombie_hp_management")
			zombie_hp_management._add_cone_head_armor()
		elif Input.is_key_pressed(KEY_F3):
			var zombie = load("res://unit/Zombie/basic_zombie/basic_zombie.tscn").instantiate()
			get_tree().current_scene.add_child(zombie)
			zombie.global_position = get_global_mouse_position()
			var zombie_hp_management = zombie.get_node("zombie_hp_management")
			zombie_hp_management._func_add_bucket_head()
		elif Input.is_key_pressed(KEY_F4):
			var zombie = load("res://unit/Zombie/basic_zombie/basic_zombie.tscn").instantiate()
			get_tree().current_scene.add_child(zombie)
			zombie.global_position = get_global_mouse_position()
			var zombie_hp_management = zombie.get_node("zombie_hp_management")
			zombie_hp_management._add_cone_head_armor()
			zombie_hp_management._func_add_bucket_head()
		elif Input.is_key_pressed(KEY_F5):
			var zombie = load("res://unit/Zombie/basic_zombie/basic_zombie.tscn").instantiate()
			var hipnotize_effect = load("res://Behaviour/hypnotize_node_effect.tscn").instantiate()
			get_tree().current_scene.add_child(zombie)
			zombie.global_position = get_global_mouse_position()
			var zombie_hp_management = zombie.get_node("zombie_hp_management")
			zombie_hp_management._func_add_bucket_head()
			zombie.add_child(hipnotize_effect)

func take_damage(source : Node, value : int = 20,):
	hp -= value
	if hp <= 0:
		hp= 10
		if source.master.has_method("kill_a_zombie"): 
			source.master.kill_a_zombie()



func _on_body_entered(body: Node) -> void:
	if body.get_groups().has("ally_projectile"):
		take_damage(body, body.damage)
		body.reduce_pierce(1)


func _on_hitpoint_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body.get_groups().has("ally_projectile"):
		take_damage(body, body.damage)
		body.reduce_pierce()


func _on_hitpoint_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_groups().has("ally_projectile"):
		take_damage(area, area.damage)
		area.reduce_pierce(1)
