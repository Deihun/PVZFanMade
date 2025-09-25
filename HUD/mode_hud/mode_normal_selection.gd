extends Control
@onready var _sun_when_claim_animation_position : Vector2 = $mode_normal_pick/sun_/SunPlacementSpecific_ForAnimation.global_position
@onready var shovel:= $Tools_UI/Shovel
@onready var powerbank:= $Tools_UI/EvolutionPowerBank
@export var hide_shovel := false
@export var hide_powerbank := false


var plant_limit := 5  #Fix it later


func get_sun_when_claim_animation_position() -> Vector2:
	return $mode_normal_pick/sun_/SunPlacementSpecific_ForAnimation.global_position


func pick_mode():
	self.show()
	$seed_picker_boarder.show()


func _ready() -> void:
	QuickDataManagement._sun_bank_position = get_sun_when_claim_animation_position()
	QuickDataManagement.mode_normal_selection = self
	QuickDataManagement.global_calls_manager._when_sun_value_change.append(Callable(self,"update_all_hud"))
	QuickDataManagement.location_where_evolutionUI_place = $location_where_evolution_tree_goes.global_position
	
	if get_parent() and get_parent() is Camera2D: 
		if get_parent().conveyor_belt:
			var conveyor = get_parent().conveyor_belt
			$mode_normal_pick/sun_.hide()
			$mode_normal_pick/plant_seed_selection.hide()
			$mode_normal_pick.add_child(conveyor)
	
	
	
	_setup_hud_plantselection_scaling()
	update_all_hud()	

func _pass_all_plants_that_is_available():
	var get_number:=0
	for child in $seed_picker_boarder/GridContainer.get_children():
		child._on_click_button_button_down()

func remove_the_seed_selection():
	$seed_picker_boarder.hide()
	for child in $mode_normal_pick/plant_seed_selection/VBoxContainer.get_children():
		child.mode=""

func start():
	QuickDataManagement.sound_manager.play_music()
	if shovel:if !hide_shovel:shovel.show()
	if powerbank:if !hide_powerbank: powerbank.show()
	if get_parent().conveyor_belt:
		get_parent().conveyor_belt.start()
	for child in $mode_normal_pick/plant_seed_selection/VBoxContainer.get_children():
		child.mode="ingame-seed-pick"
		child.start_cooldown()


func _get_number_of_seed_currently()->int:
	return $mode_normal_pick/plant_seed_selection/VBoxContainer.get_child_count()

func _get_number_of_available_seeds_currently()->int:
	return $seed_picker_boarder/GridContainer.get_child_count()

func update_all_hud():
	$"mode_normal_pick/sun_/Sun Count".text = str(QuickDataManagement.sun)
	for seedPacket in $mode_normal_pick/plant_seed_selection/VBoxContainer.get_children():
		seedPacket._change_price_font_color_to_red()

func _setup_hud_plantselection_scaling() -> void:
	var new_size : Vector2 = Vector2(250,80)
	for seedslot in  $mode_normal_pick/plant_seed_selection/VBoxContainer.get_children():
		new_size.y += seedslot.size.y
	$mode_normal_pick/plant_seed_selection.size = new_size

func _show_seedslot_affordable_indicator():
	pass


func _on_v_box_container_child_entered_tree(node: Node) -> void:
	_setup_hud_plantselection_scaling()


func _on_lets_rock_pressed() -> void:
	get_parent()._done_after_picking()
