extends Node2D

var flags := []
var flag_triggered := 0
#func _process(delta: float) -> void:
	#print($ProgressBar.position,  " global: ", $ProgressBar.global_position)

func _ready() -> void:
	$HugeWave.hide()
	$FinalWave.hide()
	set_progress(0)

func set_progress(percent: float):
	$ProgressBar.value = percent

func spawn_flag_at_progress(value: float):
	var bar_width = $ProgressBar.size.x
	var min_val = $ProgressBar.min_value
	var max_val = $ProgressBar.max_value
	var percent = (value - min_val) / (max_val - min_val)

	var new_node = load("res://HUD/borders/level_manager/flag_in_wave_indicator.tscn").instantiate()
	var x_pos = percent * bar_width
	var y_pos = 22  # Adjust if needed
	new_node.position = $ProgressBar.position + Vector2(x_pos, y_pos)
	new_node.value_requirement = value

	$ProgressBar.get_parent().add_child(new_node)
	flags.append(new_node)

func _on_progress_bar_value_changed(value: float) -> void:
	var bar_width = $ProgressBar.size.x
	var min_val = $ProgressBar.min_value
	var max_val = $ProgressBar.max_value
	var percent = (value - min_val) / (max_val - min_val)
	$ProgressBar/Node.position.x = percent * bar_width
	var checker :=false
	for flag in flags:
		checker = true if flag.check_if_can_trigger(value) else checker
	flag_triggered += 1 if checker else 0
	
	if checker and flag_triggered>=flags.size(): $AnimationPlayer.play("final_wave")
	elif checker and flag_triggered<flags.size(): $AnimationPlayer.play("huge_wave_of_zombies_are_approaching")
