extends Control

var master

@onready var reserveUI_Tiera : Sprite2D = $Boarder/Upgrade_1/ReserveUi
@onready var reserveUI_Tierb : Sprite2D = $Boarder/Upgrade_2/ReserveUi
@onready var evolve_requirement_description : Label = $Boarder/data_stored/evolve_requirement_description
@onready var evolve_texture_progress_bar : TextureProgressBar = $Boarder/ScrollContainer/data_stored/Evolution_Icon/Node2D/evolution_progress
@onready var build_description : Node2D = $Build_description

var upgrade_1_callable : Callable
var upgrade_2_callable : Callable

var already_attain_max_evolve :=false

var _if_upgradable : bool = false


#INCOMPLETE, NO UI FOR LOCKED AND MAX UPGRADES, MISSING PLANT STATS ETC

func update_name(plant_name : String) -> void :
	$Boarder/plant_name_label.text = plant_name

func set_upgrade_1(description: String):
	$Boarder/Upgrade_1/Label.text = description

func set_upgrade_status(text : String, _visibility:bool=true):
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/upgrade_status.text = text
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/upgrade_status.visible =_visibility
	if text=="EVOLUTION COMPLETE":
		$Boarder/Upgrade_1/Label.text="No more path"
		$Boarder/Upgrade_2/Label.text="No more path"

func set_tier_indicator(tier1a:bool, tier2a:bool, tier3a:bool,tier1b:bool, tier2b:bool, tier3b:bool):
	if tier1a:
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier1a_indi.claimed()
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier1b_indi.ignore()
	elif tier1b:
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier1a_indi.ignore()
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier1b_indi.claimed()
	else:
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier1a_indi.unclaimed()
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier1b_indi.unclaimed()
	if tier2a:
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier2a_indi.claimed()
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier2b_indi.ignore()
	elif tier2b:
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier2a_indi.ignore()
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier2b_indi.claimed()
	else:
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier2b_indi.unclaimed()
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier2b_indi.unclaimed()
	if tier3a:
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier3a_indi.claimed()
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier3b_indi.ignore()
	elif tier3b:
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier3a_indi.ignore()
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier3b_indi.claimed()
	else:
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier3b_indi.unclaimed()
		$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier3b_indi.unclaimed()
	already_attain_max_evolve = (tier3a or tier3b)
func _set_upgrade_2(description: String):
	$Boarder/Upgrade_2/Label.text = description
func _check_if_able_to_be_click():
	if upgrade_1_callable.is_valid() and upgrade_2_callable.is_valid():
		_if_upgradable = true
func _set_upgrade_as_max():#INCOMPLETE
	_if_upgradable = false


func _ready():
	set_process_input(true)
	mouse_filter = Control.MOUSE_FILTER_PASS 




func set_evolutionprogress(percent : float, max_value : float) -> void:
	var animation_progress = $Boarder/ScrollContainer/data_stored/Evolution_Icon/Node2D/evolution_progress/AnimationPlayer
	if already_attain_max_evolve:
		evolve_texture_progress_bar.value = evolve_texture_progress_bar.max_value
		if animation_progress.current_animation != "progress_full": animation_progress.play("progress_full")
		return
	evolve_texture_progress_bar = $Boarder/ScrollContainer/data_stored/Evolution_Icon/Node2D/evolution_progress
	evolve_texture_progress_bar.value= percent
	evolve_texture_progress_bar.max_value = max_value
	if percent < (max_value * 0.4) and animation_progress.current_animation != "progress_idle_low": animation_progress.play("progress_idle_low")
	elif percent >= (max_value * 0.4) and percent != max_value and animation_progress.current_animation != "progress_idle_half": animation_progress.play("progress_idle_half")
	elif percent >= max_value and animation_progress.current_animation != "progress_full": animation_progress.play("progress_full")

func change_texture(image : Texture)-> void:
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/Node2D/evolution_progress.texture_under = image
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/Node2D/evolution_progress.texture_progress = image


func _lock_current_tier():
	$Boarder/EvolveLocked_1.show()
	$Boarder/EvolveLocked_2.show()
	$Boarder/Upgrade_1.disabled = true
	$Boarder/Upgrade_2.disabled = true
	$Boarder/Upgrade_1.hide()
	$Boarder/Upgrade_2.hide()
	
 
func set_evolutionprogress_with_computationdifference(firstvalue_current : float, secondvalue_max : float) -> void:
	var percent_difference : float = (firstvalue_current / secondvalue_max) * 100

func _on_upgrade_1_button_up() -> void:
	master.__reserve_to_tierA = !master.__reserve_to_tierA
	master.__reserve_to_tierB = false
	master.trigger_upgrade()
	master.update_current_evolution_ui()

func _on_upgrade_2_button_up() -> void:
	master.__reserve_to_tierB = !master.__reserve_to_tierB
	master.__reserve_to_tierA = false
	master.trigger_upgrade()
	master.update_current_evolution_ui()


func set_sub_info(info : Dictionary):
	for child in $Boarder/ScrollContainer/data_stored.get_children():
		if child in [$Boarder/ScrollContainer/data_stored/Evolution_Icon, $Boarder/ScrollContainer/data_stored/evolve_requirement_description]:
			continue
		child.queue_free()

	for key in info.keys():
		var hbox = HBoxContainer.new()
		var key_label = Label.new()
		key_label.text = str(key) + ":"
		key_label.add_theme_font_size_override("font_size", 18)
		key_label.add_theme_constant_override("outline_size", 5)
		key_label.add_theme_color_override("font_outline_color", Color.BLACK)
		key_label.add_theme_color_override("font_color", Color(1, 1, 0.6)) 
		var value_label = Label.new()
		value_label.text = str(info[key])

		value_label.add_theme_font_size_override("font_size", 14)
		value_label.add_theme_constant_override("outline_size", 5)
		value_label.add_theme_color_override("font_outline_color", Color.BLACK)
		hbox.add_child(key_label)
		hbox.add_child(value_label)
		$Boarder/ScrollContainer/data_stored.add_child(hbox)

func set_evolve_requirement_description(text:String)->void:
	$Boarder/ScrollContainer/data_stored/evolve_requirement_description.text = text


func _on_upgrade_1_mouse_entered() -> void:
	$Boarder/Upgrade_1/ReserveUi.self_modulate.a = 0.2
func _on_upgrade_1_mouse_exited() -> void:
	$Boarder/Upgrade_1/ReserveUi.self_modulate.a = 1.0
func _on_upgrade_2_mouse_entered() -> void:
	$Boarder/Upgrade_2/ReserveUi.self_modulate.a = 0.2
func _on_upgrade_2_mouse_exited() -> void:
	$Boarder/Upgrade_2/ReserveUi.self_modulate.a = 1.0

var dragging := false
var last_mouse_pos := Vector2.ZERO
func _on_scroll_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				last_mouse_pos = event.position
				accept_event()
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		last_mouse_pos = event.position
		
		$Boarder/ScrollContainer.scroll_vertical -= int(delta.y)
		$Boarder/ScrollContainer.scroll_horizontal -= int(delta.x)
		accept_event()

func set_description_base_on_given_array(value:Array[String])->void:
	print("connecting?")
	$Build_description.set_description_base_on_given_array(value)
func _on_build_description_mouse_entered() -> void:
	$Build_description.show()
func _on_build_description_mouse_exited() -> void:
	$Build_description.hide()
