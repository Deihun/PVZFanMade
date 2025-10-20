extends Node2D

@onready var progress_var : ProgressBar = $ProgressBar
var flags := []
var flag_triggered := 0
var _current_index_running := 0
var _current_index := 0
var _wave_verification :Array= []

#func _process(delta: float) -> void:
	#print($ProgressBar.position,  " global: ", $ProgressBar.global_position)

func _ready() -> void:
	if get_parent() is Camera2D: $Label.text= get_parent().level_name
	$HugeWave.hide()
	$FinalWave.hide()


func add_wave(is_it_flag_wave:=false)-> void:
	_current_index +=1
	_wave_verification.append([_current_index,is_it_flag_wave,null])

func spawn_wave_markers() -> void:
	var total_waves := _wave_verification.size()
	if total_waves == 0:return
		
	var min_val := progress_var.min_value
	var max_val := progress_var.max_value
	var bar_width := progress_var.size.x

	var slice_size := float(max_val - min_val) / total_waves
	for i in total_waves:
		var wave_data = _wave_verification[i]
		var wave_index: int = wave_data[0]
		var is_flag_wave: bool = wave_data[1]

		var wave_value := min_val + slice_size * (i + 1)
		var percent := (wave_value - min_val) / (max_val - min_val)

		if is_flag_wave:
			var new_node = load("res://HUD/borders/level_manager/flag_in_wave_indicator.tscn").instantiate()

			var x_pos = percent * bar_width
			var y_pos = 22
			add_child(new_node)
			new_node.position = progress_var.position + Vector2(x_pos, y_pos)
			_wave_verification[i][2] = new_node #invalid assignment



func start_wave():
	$ProgressBar.show()
	$Label.position.x -= 300

func wave_progress() -> void:
	var total_waves := _wave_verification.size()
	if total_waves == 0: return

	if _current_index_running >= total_waves: return  
	var min_val := progress_var.min_value
	var max_val := progress_var.max_value
	var slice_size := float(max_val - min_val) / total_waves

	var wave_data = _wave_verification[_current_index_running]
	var wave_index: int = wave_data[0]
	var is_flag_wave: bool = wave_data[1]
	var _for_flags_current_running_index = _current_index_running

	var wave_value := min_val + slice_size * (wave_index)

	progress_var.value = wave_value 
	_current_index_running += 1
	if is_flag_wave:
		wave_data[2].trigger_animation()

		# Check if this is the last flag wa
		
		var is_last_flag_wave := true
		for j in range(_for_flags_current_running_index + 1, total_waves):
			if _wave_verification[j][1] == true:
				is_last_flag_wave = false
				break
		if is_last_flag_wave:
			$AnimationPlayer.play("final_wave")
			QuickDataManagement.sound_manager.play_last_wave()
		else:
			$AnimationPlayer.play("huge_wave_of_zombies_are_approaching")
			QuickDataManagement.sound_manager.play_mid_wave()
			
		#iin here how can i know if this is the last flag_wave among the queue?

#func spawn_flag_at_progress(value: float):
	#var bar_width = progress_var.size.x
	#var min_val = progress_var.min_value
	#var max_val = progress_var.max_value
	#var percent = (value - min_val) / (max_val - min_val)
#
	#var new_node = load("res://HUD/borders/level_manager/flag_in_wave_indicator.tscn").instantiate()
	#var x_pos = percent * bar_width
	#var y_pos = 22  # Adjust if needed
	#new_node.position = progress_var.position + Vector2(x_pos, y_pos)
	#new_node.value_requirement = value
#
	#progress_var.get_parent().add_child(new_node)
	#flags.append(new_node)

func _on_progress_bar_value_changed(value: float) -> void:
	var min_val := progress_var.min_value
	var max_val := progress_var.max_value
	var bar_width := progress_var.size.x

	var percent := (value - min_val) / (max_val - min_val)

	var x_pos := percent * bar_width

	var tween = create_tween()
	tween.tween_property($ProgressBar/Node, "position:x", x_pos, randf_range(0.8, 1.8))
	#var checker :=false
	#for flag in flags:
		#checker = true if flag.check_if_can_trigger(value) else checker
	#flag_triggered += 1 if checker else 0
	#
	#if checker and flag_triggered>=flags.size(): 
		#QuickDataManagement.sound_manager.play_last_wave()
		#$bigwave_sfx.play()
		#$AnimationPlayer.play("final_wave")
	#elif checker and flag_triggered<flags.size(): 
		#QuickDataManagement.sound_manager.play_mid_wave()
		#$bigwave_sfx.play()
		#$AnimationPlayer.play("huge_wave_of_zombies_are_approaching")
