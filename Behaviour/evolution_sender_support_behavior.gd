extends Area2D
@onready var savemanager := SaveManager
@export_category("Description Properties")
@export var plant_name: String
@export_multiline var description_Tier1A : String
@export_multiline var description_Tier1B : String
@export_multiline var description_Tier2A : String
@export_multiline var description_Tier2B : String
@export_multiline var description_Tier3A : String
@export_multiline var description_Tier3B : String

@export_category("Functions When Upgrade")
@export var tier1A_callable : Callable
@export var tier1B_callable : Callable
@export var tier2A_callable : Callable
@export var tier2B_callable : Callable
@export var tier3A_callable : Callable
@export var tier3B_callable : Callable

@export_category("Upgrade Requirements")
@export var _tier1_max_value : float = 100.0
@export var _tier2_max_value : float = 100.0
@export var _tier3_max_value : float = 100.0
@export var dev_mode_ignore_locked_restriction : bool= false

var current_evolution_ui 

var _current_tier : int= 0
var _percentage_value : float
var _Tier1 : int
var _Tier2: int 
var _Tier3 : int
var _TierA_Callable : Callable
var _TierB_Callable : Callable
var _can_evolve : bool = false
var _desc1
var _desc2

var _tier1a_obtain :bool = false
var _tier1b_obtain :bool = false
var _tier2a_obtain :bool = false
var _tier2b_obtain :bool = false
var _tier3a_obtain :bool = false
var _tier3b_obtain :bool = false

func _ready() -> void:
	_TierA_Callable = Callable(self,"check_for_upgradeA")
	_TierB_Callable = Callable(self,"check_for_upgradeB")
	$EvolveReadyAnimation.hide()


func boost_plants_percentage(value: float):
	print("Boost Before: ", _percentage_value)
	var percentage_val : float = _get_max_value_baseOnCurrentTier() * value
	increase_progress_evolution(percentage_val)
	print("Final: ", _percentage_value,"// Calculation = ",percentage_val ,"=",_get_max_value_baseOnCurrentTier(),"*",value)


func boost_plants_current_percentage(value: float):
	var percentage_val : float = _percentage_value * value
	increase_progress_evolution(percentage_val)


func increase_progress_evolution(value : float):
	_percentage_value += value
	if _percentage_value >= _get_max_value_baseOnCurrentTier() and _current_tier <= 2:
		_can_evolve = true
		if check_tier() or dev_mode_ignore_locked_restriction: $EvolveReadyAnimation.show()
	update_current_evolution_ui()


func _get_max_value_baseOnCurrentTier() ->float:
	match _current_tier:
		0: return _tier1_max_value
		1: return _tier2_max_value
		2: return _tier3_max_value
	return 100.0


func check_for_upgradeA():
	if _can_evolve:
		match _current_tier:
			0: 
				_tier1a_obtain=true
				tier1A_callable.call()
			1: 
				_tier2a_obtain=true
				tier2A_callable.call()
			2: 
				_tier3a_obtain=true
				tier3A_callable.call()
		_after_upgrade()


func check_for_upgradeB():
	if _can_evolve:
		match _current_tier:
			0: 
				_tier1b_obtain=true
				tier1B_callable.call()
			1: 
				_tier2b_obtain=true
				tier2B_callable.call()
			2:
				_tier3b_obtain=true
				tier3B_callable.call()
		_after_upgrade()


func _after_upgrade():
	_current_tier+= 1
	_percentage_value = 0
	_can_evolve = false
	$EvolveReadyAnimation.hide()
	update_current_evolution_ui()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#print("debug //",QuickDataManagement._selected_plant_node_as_icon)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and QuickDataManagement._selected_plant_node_as_icon:
		if QuickDataManagement._selected_plant_node_as_icon.name.contains("evolve"):
			self.boost_plants_percentage(100.0)
			QuickDataManagement._remove_plant_as_idle_plant()
		
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if Input.is_action_pressed("check_plant_in_details") and !current_evolution_ui:
			_create_the_evolution_boarder()
			update_current_evolution_ui()

func _create_the_evolution_boarder():
	var evolution_ui_ : Control = load("res://HUD/EvolutionUI/EvolutionBoarder.tscn").instantiate()
	get_tree().current_scene.add_child(evolution_ui_)
	current_evolution_ui = evolution_ui_
	if QuickDataManagement.location_where_evolutionUI_place: 
		print(QuickDataManagement.location_where_evolutionUI_place)
		current_evolution_ui.position = QuickDataManagement.location_where_evolutionUI_place
		current_evolution_ui.global_position = Vector2.ZERO
	evolution_ui_.update_name(plant_name)
	evolution_ui_.connect("tree_exited", Callable(self, "_set_current_evolution_ui_toNull"))

func update_current_evolution_ui():
	if !current_evolution_ui:
		return
	if !dev_mode_ignore_locked_restriction: if !check_tier(): current_evolution_ui. _lock_current_tier()
	current_evolution_ui.set_evolutionprogress(_percentage_value, _get_max_value_baseOnCurrentTier())
	current_evolution_ui.set_tier_indicator(_tier1a_obtain,_tier2a_obtain,_tier3a_obtain,_tier1b_obtain,_tier2b_obtain,_tier3b_obtain)
	current_evolution_ui.upgrade_1_callable = _TierA_Callable
	current_evolution_ui.upgrade_2_callable = _TierB_Callable
	if _tier3a_obtain or _tier3b_obtain: current_evolution_ui.set_upgrade_status("EVOLUTION COMPLETE",true)
	elif _percentage_value >= _get_max_value_baseOnCurrentTier(): current_evolution_ui.set_upgrade_status("EVOLVE AVAILABLE",true)
	else: current_evolution_ui.set_upgrade_status("EVOLVE AVAILABLE",false)
	match _current_tier:
		0: 
			current_evolution_ui.set_upgrade_1(description_Tier1A)
			current_evolution_ui._set_upgrade_2(description_Tier1B)
		1:
			current_evolution_ui.set_upgrade_1(description_Tier2A)
			current_evolution_ui._set_upgrade_2(description_Tier2B)
		2:
			current_evolution_ui.set_upgrade_1(description_Tier3A)
			current_evolution_ui._set_upgrade_2(description_Tier3B)

func _set_current_evolution_ui_toNull():
	current_evolution_ui = null

func check_tier():
	var is_it_unlock := true
	match _current_tier:
		0:
			is_it_unlock = QuickDataManagement.savemanager.if_plant_of_tier_exist(plant_name,"tier1")
		1:
			is_it_unlock = QuickDataManagement.savemanager.if_plant_of_tier_exist(plant_name,"tier2")
		2:
			is_it_unlock = QuickDataManagement.savemanager.if_plant_of_tier_exist(plant_name,"tier3")
	return is_it_unlock
		#if !is_it_unlock: current_evolution_ui. _lock_current_tier()
