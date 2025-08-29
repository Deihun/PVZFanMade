extends Node

var _plant_exist_in_game : Array[Node] = []
var _plant_enter_the_board : Array[Callable]= []
var _plant_exit_the_board : Array[Callable]= []
var _plant_boost_value_change : Array[Callable]= []
var _when_plant_evolve : Array[Callable]= []
var _when_sun_value_change : Array[Callable]= []
var _when_sun_collected : Array[Callable]= []
var _when_zombie_killed : Array[Callable]= []


func reset():
	_plant_exist_in_game = []
	_plant_enter_the_board = []
	_plant_exit_the_board = []
	_when_sun_value_change = []
	_when_sun_collected = []
	_when_zombie_killed = []


func plant_exist_in_game_trigger():
	for method in _plant_enter_the_board:
		if method.is_valid(): method.call()
		else: _plant_enter_the_board.erase(method)

func plant_exit_the_board_trigger():
	for method in _plant_exit_the_board:
		if method.is_valid(): method.call()
		else: _plant_exit_the_board.erase(method)

func plant_boost_value_change_trigger():
	for method in _plant_boost_value_change:
		if method.is_valid(): method.call()
		else: _plant_boost_value_change.erase(method)

func when_sun_value_change_trigger():
	for method in _when_sun_value_change:
		if method.is_valid(): method.call()
		else: _when_sun_value_change.erase(method)

func when_sun_collected_trigger():
	for method in _when_sun_collected:
		if method.is_valid(): method.call()
		else: _when_sun_collected.erase(method)

func when_zombie_killed_trigger():
	for method in _when_zombie_killed:
		if method.is_valid(): method.call()
		else: _when_zombie_killed.erase(method)

func when_plant_evolve_trigger():
	for method in _when_plant_evolve:
		if method.is_valid(): method.call()
		else: _when_plant_evolve.erase(method)
