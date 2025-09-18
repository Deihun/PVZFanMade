extends Camera2D

@export_enum("normal_mode_with_pick","dont_check_zombie","check_zombie_with_picking","dont_show_plant_pick") var _mode :String
@export var auto_start := true
@export var delay_before_auto_start := 0.0
@export var conveyor_belt : Node2D
@export var sun_on_start := 50
@export var level_name : String


@export_category("MUSIC")
@export var choose_our_seed_music : AudioStream 
@export var music_at_start : AudioStream
@export var music_mid_wave : AudioStream
@export var music_last_wave : AudioStream

var initial_position_:= Vector2(421.0,136.0)
var last_position:= Vector2(1950.0,136.0)
var when_starting_callable : Array[Callable] = []

var game_over_trigger :=false



func _ready() -> void:
	QuickDataManagement.sound_manager.start_up_wave = music_at_start
	QuickDataManagement.sound_manager.mid_wave = music_mid_wave
	QuickDataManagement.sound_manager.last_wave = music_last_wave
	QuickDataManagement._reset_all_data()
	QuickDataManagement.sound_manager.play_music(choose_our_seed_music)
	QuickDataManagement.change_sun_value(sun_on_start)
	$HUD_normal_selection.hide()
	if auto_start: 
		await get_tree().create_timer(delay_before_auto_start).timeout
		play_camera()


func play_camera():
	$HUD_normal_selection.hide()
	match _mode:
		"normal_mode_with_pick":
			await get_tree().create_timer(2.0).timeout
			_camera_navigating_to_zombie()
			if $HUD_normal_selection._get_number_of_available_seeds_currently() <= QuickDataManagement.savemanager.get_plant_limit_cap():
				$HUD_normal_selection._pass_all_plants_that_is_available()
				$HUD_normal_selection.remove_the_seed_selection()
				await get_tree().create_timer(4.0).timeout
				_camera_navigating_to_house()
				await get_tree().create_timer(2.0).timeout
				ready_get_set_plant()
				$HUD_normal_selection.start()
				await start_call_all_methods()
				$HUD_normal_selection.show()
			else:
				$HUD_normal_selection.pick_mode()
		"check_zombie_with_picking":
			pass
		"dont_show_plant_pick":
			await get_tree().create_timer(2.0).timeout
			_camera_navigating_to_zombie()
			await get_tree().create_timer(5.0).timeout
			_camera_navigating_to_house()
			await get_tree().create_timer(2.0).timeout
			ready_get_set_plant()
			await start_call_all_methods()
			$HUD_normal_selection.start()
		

func _done_after_picking():
	$HUD_normal_selection.remove_the_seed_selection()
	_camera_navigating_to_house()
	await get_tree().create_timer(4.0).timeout
	await ready_get_set_plant()
	$HUD_normal_selection.start()
	start_call_all_methods()

func ready_get_set_plant():
	$AudioStreamPlayer.play()
	$Ready.show()
	await get_tree().create_timer(0.4).timeout
	$Ready.texture=load("res://HUD/mode_hud/get_set_text.png")
	await get_tree().create_timer(0.5).timeout
	$Ready.texture=load("res://HUD/mode_hud/plant_text.png")
	await get_tree().create_timer(1.0).timeout
	$Ready.hide()

func _camera_navigating_to_zombie():
	var tween = create_tween()
	tween.tween_property(self, "position", last_position, 2.0) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)


func _camera_navigating_to_house():
	var tween = create_tween()
	tween.tween_property(self, "position", initial_position_, 2.0) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN_OUT)

func start_call_all_methods():
	for method  in when_starting_callable:
		if method.is_valid():method.call()
		else: when_starting_callable.erase(method)


func game_over(enemy_who_enter : Node2D):
	if game_over_trigger: return
	enemy_who_enter.add_to_group("ignore")
	game_over_trigger = true
	var enemy_global_position = enemy_who_enter.global_position
	var game_over_scene := preload("res://Resource/game_over/game_over_scene.tscn").instantiate()
	add_child(game_over_scene)
	game_over_scene.position += Vector2(-960,-540)
	get_tree().current_scene.remove_child(enemy_who_enter)
	game_over_scene.add_child(enemy_who_enter)
	enemy_who_enter.global_position = enemy_global_position
	enemy_who_enter.z_index = 205
	await get_tree().create_timer(3.0).timeout
	print(game_over_scene.get_children())
