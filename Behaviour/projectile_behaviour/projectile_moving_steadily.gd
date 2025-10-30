extends Node

@export_enum("LEFT","RIGHT","UP","DOWN") var direction: String="RIGHT"
@export var auto_start :bool = false
@export var travel_limit_enable:bool = false
@export var enable_slowing_down : bool = false
@export_category("Travel Limit Property")
@export var fade_out_when_nearing_end := false
@export var travel_limit_value:float = 1.0
@export_enum("DELETE_BEHAVIOUR","DELETE_PARENT") var set_moode:String="DELETE_BEHAVIOUR"

var current_value:float = 0
var slowdown_value_factor := 1.0

func free() -> void:
	set_process(auto_start)

func _physics_process(delta: float) -> void:
	if !get_parent():return
	var parent :Node2D=get_parent()
	if direction == "RIGHT":
		parent.position.x+= (parent.speed*(delta*1.0)) *slowdown_value_factor
	elif direction == "LEFT":
		parent.position.x-= (parent.speed*(delta*1.0)) *slowdown_value_factor
	elif direction == "UP":
		parent.position.y-= (parent.speed*(delta*1.0)) *slowdown_value_factor
	elif direction == "DOWN":
		parent.position.y+= (parent.speed*(delta*1.0)) *slowdown_value_factor
	
	if travel_limit_enable:
		current_value+=1
		if enable_slowing_down:
			slowdown_value_factor = 1.0 - (current_value / travel_limit_value)
			if slowdown_value_factor < 0.5 and fade_out_when_nearing_end: _trigger_fade_out()
		if current_value >= travel_limit_value:
			match set_moode:
				"DELETE_BEHAVIOUR":
					self.queue_free()
				"DELETE_PARENT":
					get_parent().queue_free()

var _is_trigger_fade_out = false
func _trigger_fade_out()-> void:
	if _is_trigger_fade_out: return
	_is_trigger_fade_out = true
	var parent : Node2D = get_parent()
	var tween = create_tween()
	tween.tween_property(parent, "modulate:a", 0.0, 0.5)
