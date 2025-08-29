extends Node2D

func _ready() -> void:
	$chatter_box.hide()
	$chatter_box/input_textEdit.gui_input.connect(_on_textedit_input)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		if Input.is_key_pressed(KEY_F1):
			$chatter_box.visible = !$chatter_box.visible

func _on_textedit_input(event: InputEvent):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		_submit_text()

func _submit_text():
	$chatter_box/input_textEdit.text = $chatter_box/input_textEdit.text.replace("\n", "")
	var for_checking = $chatter_box/input_textEdit.text.replace(" ","")
	if for_checking =="":return
	_send_label_as_preview("- "+$chatter_box/input_textEdit.text)
	_process_the_command()
	$chatter_box/input_textEdit.text = ""


func _send_label_as_preview(text:String, color:=0):
	var label:=Label.new()
	label.text = text
	$chatter_box/ScrollContainer/holder_for_textbox.add_child(label)
	match color:
		1:
			label.add_theme_color_override("font_color", Color.YELLOW)
		2:
			label.add_theme_color_override("font_color", Color.RED)
		_:
			pass 

func _process_the_command():
	var command : String = $chatter_box/input_textEdit.text
	if command.begins_with("reset save data"):
		QuickDataManagement.savemanager._reset_save()
		_send_label_as_preview("data has reset successfully",1)
	elif command.begins_with("get sun"):
		_send_label_as_preview("successfully gain sun",1)
	else: _send_label_as_preview(("command '"+$chatter_box/input_textEdit.text+"' is unrecognizable "),2)
	
	#match $chatter_box/input_textEdit.text:
		#"reset save data":
			#_send_label_as_preview("data has reset successfully",1)
			#pass
		#_:
			#_send_label_as_preview("command is unrecognizable",2)
	
