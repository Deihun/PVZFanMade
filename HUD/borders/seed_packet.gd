extends Control
@export_enum("ingame-seed-pick","one-time-used","only-for-plant-selection","click-to-delete-only") var mode :String 
@export var plant_name : String
@export var cooldown : int = 20
@export var start_up_cooldown : int = 5
@export var suncost : int = 100
@export_file("*.png", "*.jpg", "*.jpeg", "*.webp") var image_path: String
@export_file("*.tscn") var plant_tscn: String
@export_file("*.tscn") var plant_animation_only_tscn: String
@export var land_type :=  true
@export var water_type :=  false
@export var can_be_planted_under :=  false
@export_category("function properties")
@export var seed_selection_VBoxContainer : Node
@export var delete_if_not_existing_in_progress := true

var first_time_plant := true
var current_timer : int = 0
var call_plant_method : Callable


func _ready() -> void:
	add_to_group("seed_packet")
	_change_price_font_color_to_red()
	if delete_if_not_existing_in_progress and !QuickDataManagement.savemanager.plant_exist(plant_name): queue_free()
	if image_path: $SeedPacket.texture = load(image_path)
	if mode == "one-time-used":
		suncost = 0
		$SUNCOST.hide()
	

func start_cooldown():
	current_timer = start_up_cooldown if first_time_plant else cooldown
	$ContentFrame/ProgressBar.show()
	$ContentFrame/ProgressBar.min_value = 0.0
	$ContentFrame/ProgressBar.max_value = cooldown
	$cooldown.start()
	first_time_plant=false


func _on_cooldown_timeout() -> void:
	current_timer-= 1
	_check_if_cd_finished()

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


func _on_click_button_button_down() -> void:
	match mode:
		"ingame-seed-pick":
			if QuickDataManagement._selected_data_in_seed_packet == self:
				QuickDataManagement._remove_plant_for_queue_plant()
				return
			if current_timer > 0:return
			if QuickDataManagement.sun >= suncost:
				QuickDataManagement._add_plant_for_queue_plant(self,load(plant_animation_only_tscn).instantiate())
				#NEED FUNCTION FOR CANCEL SELECTION UI TO OTHER SEEDPACKET YET, Also SECURE THE SEEDPACKET LATER TOO!
			if !call_plant_method: return
			call_plant_method.call()
		"one-time-used":#still in progress for night plants
			if QuickDataManagement._selected_data_in_seed_packet == self:
				QuickDataManagement._remove_plant_for_queue_plant()
				return
			if current_timer > 0:return
			QuickDataManagement._add_plant_for_queue_plant(self,load(plant_animation_only_tscn).instantiate())
			if !call_plant_method: return
			call_plant_method.call()
		"only-for-plant-selection":
			if seed_selection_VBoxContainer:
				for child in seed_selection_VBoxContainer.get_children():
					if child.plant_name == plant_name: return
				var pickable_version_of_myself := self.duplicate()
				pickable_version_of_myself.mode="click-to-delete-only"
				seed_selection_VBoxContainer.add_child(pickable_version_of_myself)
		"click-to-delete-only":
			self.queue_free()


func successfully_planted() -> void:
	if mode == "one-time-used":
		queue_free()
		return
	else:
		current_timer = cooldown
		_check_if_cd_finished()
		start_cooldown()

func _change_price_font_color_to_red(value : bool = true)-> void:
	$SUNCOST.text = str(suncost)
	if value: 
		if (QuickDataManagement.sun >= suncost):
			$SUNCOST.remove_theme_color_override("font_color")
			$VISUAL_AFFORD.hide()
			return
		else:
			$SUNCOST.add_theme_color_override("font_color",Color.DARK_RED)
			$VISUAL_AFFORD.show()
