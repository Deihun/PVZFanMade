extends Node2D

@onready var progress_var : ProgressBar = $ProgressBar
var flags := []
var flag_triggered := 0
#func _process(delta: float) -> void:
	#print($ProgressBar.position,  " global: ", $ProgressBar.global_position)

func _ready() -> void:
	if get_parent() is Camera2D: $Label.text= get_parent().level_name
	$HugeWave.hide()
	$FinalWave.hide()
	set_progress(0)

func set_progress(percent: float):
	progress_var.value = percent

func spawn_flag_at_progress(value: float):
	var bar_width = progress_var.size.x
	var min_val = progress_var.min_value
	var max_val = progress_var.max_value
	var percent = (value - min_val) / (max_val - min_val)

	var new_node = load("res://HUD/borders/level_manager/flag_in_wave_indicator.tscn").instantiate()
	var x_pos = percent * bar_width
	var y_pos = 22  # Adjust if needed
	new_node.position = progress_var.position + Vector2(x_pos, y_pos)
	new_node.value_requirement = value

	progress_var.get_parent().add_child(new_node)
	flags.append(new_node)

func start_wave():
	$ProgressBar.show()
	$Label.position.x -= 300

func _on_progress_bar_value_changed(value: float) -> void:
	var bar_width = progress_var.size.x
	var min_val = progress_var.min_value
	var max_val = progress_var.max_value
	var percent = (value - min_val) / (max_val - min_val)
	var tween : Tween = create_tween()
	tween.tween_property($ProgressBar/Node,"position:x",(percent * bar_width),randf_range(0.8,1.8))
	#$ProgressBar/Node.position.x = percent * bar_width
	var checker :=false
	for flag in flags:
		checker = true if flag.check_if_can_trigger(value) else checker
	flag_triggered += 1 if checker else 0
	
	if checker and flag_triggered>=flags.size(): 
		QuickDataManagement.sound_manager.play_last_wave()
		$bigwave_sfx.play()
		$AnimationPlayer.play("final_wave")
	elif checker and flag_triggered<flags.size(): 
		QuickDataManagement.sound_manager.play_mid_wave()
		$bigwave_sfx.play()
		$AnimationPlayer.play("huge_wave_of_zombies_are_approaching")
