extends Area2D

var slowdown_fraction := 0.3
var tracked_zombies: Array = []
var amount_of_time_before_i_disappear := 5.0

var goo_detected_count = 0

var direction_id : int
var movement_goo : float

func _ready() -> void:
	add_to_group("chomper_goo")
	initialize_texture()
	direction_id = randi_range(1,4)
	movement_goo = randf_range(0.5,3.0)
	$expiration.wait_time = amount_of_time_before_i_disappear
	$expiration.start()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	_move_cause_theres_goo_nearby()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("zombie") and !body.is_in_group("testing"): # make sure zombies are in a "zombie" group
		tracked_zombies.append(body)
		var movement = body.get_node("zombie_movement_management")
		movement.position_changed.connect(_on_zombie_moved.bind(body))


func _on_body_exited(body: Node) -> void:
	if body in tracked_zombies:
		var movement = body.get_node("zombie_movement_management")
		tracked_zombies.erase(body)
		if movement.position_changed.is_connected(_on_zombie_moved):
			movement.position_changed.disconnect(_on_zombie_moved)

func _on_zombie_moved(new_position: Vector2, zombie_movement_per_tick: float, zombie: Node) -> void:
	var allowed_dx = abs(zombie_movement_per_tick) * slowdown_fraction
	zombie.global_position.x += allowed_dx



func _on_expiration_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if !area.is_in_group("chomper_goo"): return
	goo_detected_count +=1
	if area.movement_goo == movement_goo: movement_goo = 4.5
func _on_area_exited(area: Area2D) -> void:
	if !area.is_in_group("chomper_goo"): return
	goo_detected_count-=1
func _move_cause_theres_goo_nearby()-> void:
	if goo_detected_count <= 0: return
	match (direction_id):
		1: global_position.x += movement_goo
		2: global_position.x -= movement_goo
		3: global_position.y += movement_goo
		4: global_position.y -= movement_goo


func initialize_texture()-> void:
	var image = ["res://unit/plant/Chomper/goo_1.png","res://unit/plant/Chomper/goo_2.png","res://unit/plant/Chomper/goo_3.png"]
	$Goo1.texture = load(image.pick_random())
