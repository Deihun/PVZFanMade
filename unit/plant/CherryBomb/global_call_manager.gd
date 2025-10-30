extends Node

signal _select_to_hold_plants_seedpacket 
signal _release_a_selected_attach_to_cursor

signal _when_plants_enter_the_board(plants : Node)
signal _when_plants_exit_the_board(plants : Node)
signal _when_plant_dies(plants : Node)
signal _when_plant_boost_value_change(value_change_into : int)
signal _when_plants_evolve(plant : Node)
signal _when_sun_value_change(value_change_into : int)
signal _when_sun_is_collected()
signal _when_a_zombie_is_defeated()



var _plant_exist_in_game : Array[Node] = []
