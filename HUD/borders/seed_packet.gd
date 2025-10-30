extends Control
@export_enum("ingame-seed-pick","one-time-used","only-for-plant-selection","click-to-delete-only") var mode :String 
@export var plant_name : String
@export_multiline var description : String = ""
@export var cooldown : int = 20
@export var start_up_cooldown : int = 5
@export var suncost : int = 100
## Change the value to add limit on this plant and delete itself if theres no more plant.  (-1) == (if plant has no limit)
@export var limited_amount := -1
@export_file("*.png", "*.jpg", "*.jpeg", "*.webp") var image_path: String
@export_file("*.tscn") var plant_tscn: String
@export_file("*.tscn") var plant_animation_only_tscn: String
@export var land_type :=  true
@export var water_type :=  false
@export var can_be_planted_under :=  false
@export var take_tiles_space := true
@export_category("function properties")
@export var seed_selection_VBoxContainer : Node
@export var delete_if_not_existing_in_progress := true

var seed_selection_columncontainer : Node
var first_time_plant := true

var current_timer : int = 0
var call_plant_method : Callable

var _is_holding := false
var _hold_elapsed : float = 0.0
var _press_time: float = 0.0
const _HOLD_THRESHOLD := 0.12
var _select_the_plant_trigger := false


signal _after_used


func _ready() -> void:
	add_to_group("seed_packet")
	_change_price_font_color_to_red()
	if get_parent() is GridContainer: seed_selection_columncontainer = get_parent()
	if delete_if_not_existing_in_progress and !QuickDataManagement.savemanager.plant_exist(plant_name): queue_free()
	if image_path: $SeedPacket.texture = load(image_path)
	if limited_amount > 0: $AMOUNT.show()
	if mode == "one-time-used":
		suncost = 0
		$SUNCOST.hide()

func _process(delta: float) -> void:
	if _is_holding:
		var unscaled_delta = delta
		if Engine.time_scale != 0.0:
			unscaled_delta = delta / Engine.time_scale
		_hold_elapsed += unscaled_delta
		if _hold_elapsed >= _HOLD_THRESHOLD:
			_select_the_plant() 



func _select_the_plant() -> void:
	if _select_the_plant_trigger: return
	_select_the_plant_trigger = true
	_click_trigger()

func start_cooldown() -> void:
	current_timer = start_up_cooldown if first_time_plant else cooldown
	$ContentFrame/ProgressBar.show()
	$ContentFrame/ProgressBar.min_value = 0.0
	$ContentFrame/ProgressBar.max_value = cooldown
	$cooldown.start()
	first_time_plant=false



func _check_if_cd_finished()-> void:
	if current_timer <= 0:
		$ContentFrame/ProgressBar.hide()
	else:
		$cooldown.start()
		$ContentFrame/ProgressBar.value = current_timer


func _spawn_refund_cooldown_animation():
	var refund_animation = load("res://HUD/borders/refund_timer.tscn").instantiate()
	refund_animation.global_position = global_position + Vector2(75, 0)
	add_child(refund_animation)


func _refund_cooldown_base_value(value : int):
	current_timer -= value
	_spawn_refund_cooldown_animation()
	_check_if_cd_finished()

func _refund_cooldown_percentage_value(value : float = 0.1):
	current_timer -= int(value * cooldown)
	_spawn_refund_cooldown_animation()
	_check_if_cd_finished()

func _refund_cooldown_current_percentage_value(value : float = 0.1):
	current_timer -= int(value * current_timer)
	_spawn_refund_cooldown_animation()
	_check_if_cd_finished()

func _click_trigger(_is_hold:= false) -> void:
	match mode:
		"ingame-seed-pick":
			if QuickDataManagement._selected_data_in_seed_packet == self:
				QuickDataManagement._remove_plant_for_queue_plant()
				return
			if current_timer > 0:
				$decline_audio.play()
				return
			if QuickDataManagement.sun >= suncost:
				QuickDataManagement._add_plant_for_queue_plant(self,load(plant_animation_only_tscn).instantiate())
				$pick_.play()
			else: $decline_audio.play()
			if !call_plant_method: return
			call_plant_method.call()
		"one-time-used":#still in progress for night plants
			if QuickDataManagement._selected_data_in_seed_packet == self:
				QuickDataManagement._remove_plant_for_queue_plant()
				return
			if current_timer > 0:return
			QuickDataManagement._add_plant_for_queue_plant(self,load(plant_animation_only_tscn).instantiate())
			$pick_.play()
			if !call_plant_method: return
			call_plant_method.call()
		"only-for-plant-selection":
			if seed_selection_VBoxContainer:
				if seed_selection_VBoxContainer.get_child_count() >= QuickDataManagement.savemanager.get_plant_limit_cap(): return
				for child in seed_selection_VBoxContainer.get_children():
					if child.plant_name == plant_name: return
				var pickable_version_of_myself := self.duplicate()
				pickable_version_of_myself.mode="click-to-delete-only"
				seed_selection_VBoxContainer.add_child(pickable_version_of_myself)
				pickable_version_of_myself.seed_selection_columncontainer = get_parent()
				self.modulate = Color("5d5d5d")
		"click-to-delete-only":
			if seed_selection_columncontainer:
				for child in seed_selection_columncontainer.get_children(): if child.plant_name == self.plant_name: child.modulate = Color("ffffff")
			self.queue_free()

func selected_as_object(is_it_selected := false) -> void:
	$SeedPacket/selected_visuals.visible = is_it_selected



func successfully_planted() -> void:
	_after_used.emit()
	_handle_amount_function()
	if mode == "one-time-used":
		self.queue_free()
		return
	else:
		current_timer = cooldown
		_check_if_cd_finished()
		start_cooldown()

func _change_price_font_color_to_red(value : bool = true)-> void:
	if mode in ["only-for-plant-selection","click-to-delete-only"]:
		$SUNCOST.remove_theme_color_override("font_color")
		$VISUAL_AFFORD.hide()
		$SUNCOST.text = str(suncost)
		return
	if value: 
		if (QuickDataManagement.sun >= suncost):
			$SUNCOST.remove_theme_color_override("font_color")
			$VISUAL_AFFORD.hide()
			return
		else:
			$SUNCOST.add_theme_color_override("font_color",Color.DARK_RED)
			$VISUAL_AFFORD.show()

func _handle_amount_function() ->void:
	limited_amount = -1 if limited_amount <= -1 else limited_amount -1
	_handle_amount_label()
	if limited_amount <= -1 or limited_amount > 0: return
	self.queue_free()

func _handle_amount_label(amount : int = limited_amount) -> void:
	limited_amount = amount
	if limited_amount <= -1: return
	if $AMOUNT: 
		$AMOUNT.show()
		$AMOUNT.text = str(amount,"x")

func change_mode(_mode : String = mode) -> void:
	mode = _mode
	match mode:
		"ingame-seed-pick":
			pass
		"only-for-plant-selection":
			pass
		"click-to-delete-only":
			pass


func _on_click_button_button_up() -> void:
	if _hold_elapsed >= _HOLD_THRESHOLD:
		var tile = QuickDataManagement.get_tile_under_mouse()
		if tile:
			if QuickDataManagement._selected_plant_node_as_icon:
				if QuickDataManagement._selected_plant_node_as_icon.name.begins_with("shovel"):
					if tile.has_method("remove_top_plant"):
						tile.remove_top_plant()
					QuickDataManagement._remove_plant_for_queue_plant()
				elif QuickDataManagement._selected_plant_node_as_icon.name.begins_with("power"):
					if tile.has_method("power_occupied_tile"):
						tile.power_occupied_tile()
					QuickDataManagement._remove_plant_for_queue_plant()
				elif QuickDataManagement._selected_data_in_seed_packet:
					if tile.has_method("plant_on_this_tile"):
						tile.plant_on_this_tile(QuickDataManagement._selected_data_in_seed_packet)
					QuickDataManagement._remove_plant_for_queue_plant()
		else:
			QuickDataManagement._remove_plant_for_queue_plant()
	else: _click_trigger()
	_hold_elapsed = 0.0
	_is_holding = false
func _on_click_button_button_down() -> void:
	_select_the_plant_trigger = false
	_is_holding = true
func _on_cooldown_timeout() -> void:
	current_timer-= 1
	_check_if_cd_finished()
