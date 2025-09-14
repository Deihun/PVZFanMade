extends Control

var master

@onready var reserveUI_Tiera : Sprite2D = $Boarder/Upgrade_1/ReserveUi
@onready var reserveUI_Tierb : Sprite2D = $Boarder/Upgrade_2/ReserveUi
@onready var evolve_requirement_description : Label = $Boarder/data_stored/evolve_requirement_description

var upgrade_1_callable : Callable
var upgrade_2_callable : Callable


var _if_upgradable : bool = false


#INCOMPLETE, NO UI FOR LOCKED AND MAX UPGRADES, MISSING PLANT STATS ETC

func update_name(plant_name : String) -> void :
	$Boarder/plant_name_label.text = plant_name

func set_upgrade_1(description: String):
	$Boarder/Upgrade_1/Label.text = description

func set_upgrade_status(text : String, _visibility:bool=true):
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/upgrade_status.text = text
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/upgrade_status.visible =_visibility
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/evolution_progress.visible=!_visibility
	if text=="EVOLUTION COMPLETE":
		$Boarder/Upgrade_1/Label.text="No more path"
		$Boarder/Upgrade_2/Label.text="No more path"

func set_tier_indicator(tier1a:bool, tier2a:bool, tier3a:bool,tier1b:bool, tier2b:bool, tier3b:bool):
	var claim : Texture = load("res://HUD/borders/claim_evolution_ui_indicator.png")
	var unclaim : Texture = load("res://HUD/borders/not_claim_evolution_ui_indicator.png")
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier1A_indicator.texture = claim if tier1a else unclaim
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier2A_indicator.texture = claim if tier2a else unclaim
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier3A_indicator.texture = claim if tier3a else unclaim
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier1B_indicator.texture = claim if tier1b else unclaim
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier2B_indicator.texture = claim if tier2b else unclaim
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/EvolutionUiIndicator/tier3B_indicator.texture = claim if tier3b else unclaim


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


func _input(event):
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#var local_mouse_pos = get_local_mouse_position()
		#if not Rect2(Vector2.ZERO, size).has_point(local_mouse_pos):
			#queue_free()
	pass

func set_evolutionprogress(percent : float, max_value : float) -> void:
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/evolution_progress.value= percent
	$Boarder/ScrollContainer/data_stored/Evolution_Icon/evolution_progress.max_value = max_value

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
