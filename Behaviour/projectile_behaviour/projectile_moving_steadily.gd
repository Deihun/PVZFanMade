extends Node

@export_enum("LEFT","RIGHT","UP","DOWN") var direction: String="RIGHT"
@export var auto_start :bool = false
@export var travel_limit_enable:bool = false
@export_category("Travel Limit Property")
@export var travel_limit_value:float = 1.0
@export_enum("DELETE_BEHAVIOUR","DELETE_PARENT") var set_moode:String="DELETE_BEHAVIOUR"

var current_value:float = 0

func free() -> void:
	set_process(auto_start)

func _process(delta: float) -> void:
	if !get_parent():return
	var parent :Node2D=get_parent()
	if direction == "RIGHT":
		parent.position.x+=parent.speed*(delta*1.0)
	elif direction == "LEFT":
		parent.position.x-=parent.speed*(delta*1.0)
	elif direction == "UP":
		parent.position.y-=parent.speed*(delta*1.0)
	elif direction == "DOWN":
		parent.position.y+=parent.speed*(delta*1.0)
	
	if travel_limit_enable:
		current_value+=1
		if current_value >= travel_limit_value:
			match set_moode:
				"DELETE_BEHAVIOUR":
					self.queue_free()
				"DELETE_PARENT":
					get_parent().queue_free()
