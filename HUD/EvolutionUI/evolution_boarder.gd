extends Control

var master

var upgrade_1_callable : Callable
var upgrade_2_callable : Callable

var _if_upgradable : bool = false


#INCOMPLETE, NO UI FOR LOCKED AND MAX UPGRADES, MISSING PLANT STATS ETC

func update_name(plant_name : String) -> void :
	$Boarder/plant_name_label.text = plant_name

func set_upgrade_1(description: String):
	$Boarder/Upgrade_1/Label.text = description

func set_upgrade_status(text : String, _visibility:bool=true):
	$Boarder/upgrade_status.text = text
	$Boarder/upgrade_status.visible =_visibility
	$Boarder/evolution_progress.visible=!_visibility
	if text=="EVOLUTION COMPLETE":
		$Boarder/Upgrade_1/Label.text="No more path"
		$Boarder/Upgrade_2/Label.text="No more path"

func set_tier_indicator(tier1a:bool, tier2a:bool, tier3a:bool,tier1b:bool, tier2b:bool, tier3b:bool):
	var claim : Texture = load("res://HUD/borders/claim_evolution_ui_indicator.png")
	var unclaim : Texture = load("res://HUD/borders/not_claim_evolution_ui_indicator.png")
	$Boarder/EvolutionUiIndicator/tier1A_indicator.texture = claim if tier1a else unclaim
	$Boarder/EvolutionUiIndicator/tier2A_indicator.texture = claim if tier2a else unclaim
	$Boarder/EvolutionUiIndicator/tier3A_indicator.texture = claim if tier3a else unclaim
	$Boarder/EvolutionUiIndicator/tier1B_indicator.texture = claim if tier1b else unclaim
	$Boarder/EvolutionUiIndicator/tier2B_indicator.texture = claim if tier2b else unclaim
	$Boarder/EvolutionUiIndicator/tier3B_indicator.texture = claim if tier3b else unclaim


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
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_mouse_pos = get_local_mouse_position()
		if not Rect2(Vector2.ZERO, size).has_point(local_mouse_pos):
			queue_free()

func set_evolutionprogress(percent : float, max_value : float) -> void:
	$Boarder/evolution_progress.value= percent
	$Boarder/evolution_progress.max_value = max_value

func _lock_current_tier():
	$Boarder/EvolveLocked_1.show()
	$Boarder/EvolveLocked_2.show()
	$Boarder/Upgrade_1.disabled = true
	$Boarder/Upgrade_2.disabled = true
	$Boarder/Upgrade_1.modulate.a = 0.3
	$Boarder/Upgrade_2.modulate.a = 0.3
 
func set_evolutionprogress_with_computationdifference(firstvalue_current : float, secondvalue_max : float) -> void:
	var percent_difference : float = (firstvalue_current / secondvalue_max) * 100

func _on_upgrade_1_button_up() -> void:
	if upgrade_1_callable.is_valid():upgrade_1_callable.call()

func _on_upgrade_2_button_up() -> void:
	if upgrade_2_callable.is_valid(): upgrade_2_callable.call()
