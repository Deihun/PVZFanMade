extends Node

const ENCRYPTION_KEY := "my_super_secret_key_32bytes!" 
var save_path: String
var save_data: Dictionary = {}

# Default data for reset/new save
const DEFAULT_SAVE_DATA := {
	"plant_unlock": [ { "peashooter": [] } ],
	"shop_upgrade": [ {} ],
	"level_complete": [ {} ],
	"plant_limit_cap": 5,
	"music": 100.0,
	"sfx" : 100.
}

func _ready() -> void:
	var folder_path = OS.get_user_data_dir().path_join("MyGameSave")
	DirAccess.make_dir_recursive_absolute(folder_path)
	save_path = folder_path.path_join("SaveFile.dat")
	if FileAccess.file_exists(save_path):
		load_game()
	else:
		_reset_save() 


func save_game() -> void:
	var json_str := JSON.stringify(save_data, "\t") # formatted for readability before encryption

	var enc := FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, ENCRYPTION_KEY)
	if enc:
		enc.store_string(json_str)
		enc.close()
	else:
		push_error("Failed to open save file for writing: " + save_path)


func _test_get_jsonfile_content():
	var file := FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ, ENCRYPTION_KEY)
	if file:
		var content: String = file.get_as_text()
		file.close()
		var parsed: Variant = JSON.parse_string(content)
		if typeof(parsed) == TYPE_DICTIONARY:
			save_data = parsed as Dictionary
		return content


func load_game() -> void:
	var file := FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ, ENCRYPTION_KEY)
	if file:
		var content: String = file.get_as_text()
		file.close()
		var parsed: Variant = JSON.parse_string(content)
		if typeof(parsed) == TYPE_DICTIONARY:
			save_data = parsed as Dictionary
		else:
			push_error("Save file corrupted. Resetting to default.")
			_reset_save()
	else:
		push_error("Failed to open save file for reading: " + save_path)


func set_value(key: String, value) -> void:
	save_data[key] = value
	save_game()


func get_value(key: String, default_value = null):
	return save_data.get(key, default_value)


func plant_exist(plant_name: String) -> bool:
	for plant_entry in save_data.get("plant_unlock", []):
		if plant_name in plant_entry:
			return true
	return false

func tool_exist(tool_name: String) -> bool:
	for tool_entry in save_data.get("shop_upgrade", []):
		if tool_name in tool_entry:
			return true
	return false

func level_exist(level_name : String) -> bool:
	for level_selection in save_data.get("level_complete", []):
		if level_name in level_selection:
			return true
	return false

func if_plant_of_tier_exist(plant_name: String, tier_name: String) -> bool:
	for plant_entry in save_data.get("plant_unlock", []):
		if plant_name in plant_entry:
			var tiers: Array = plant_entry[plant_name]
			if tier_name in tiers:
				return true
			return false
	return false 


func unlock_new_plant(plant_name: String) -> void:
	if not plant_exist(plant_name):
		save_data["plant_unlock"].append({plant_name: []})
		save_game() 

func unlock_new_tools(tool_name: String)->void:
	if not plant_exist(tool_name):
		save_data["shop_upgrade"].append({tool_name: []})
		save_game() 

func unlock_tier(plant_name: String, tier_name: String) -> void:
	for plant_entry in save_data.get("plant_unlock", []):
		if plant_name in plant_entry:
			var tiers: Array = plant_entry[plant_name]
			if tier_name not in tiers:
				tiers.append(tier_name)
				save_game()
			return  

func unlock_upgrade_on_tools(tool_name: String, upgrade_name: String) -> void:
	for tool_upgrade in save_data.get("shop_upgrade", []):
		if tool_name in tool_upgrade:
			var upgrade: Array = tool_upgrade[tool_name]
			if upgrade_name not in upgrade:
				upgrade.append(upgrade_name)
				save_game()
			return  

func complete_level(level_name : String) -> void:
	if not level_exist(level_name):
		save_data["level_complete"].append({level_name: []})
		save_game() 


func _reset_save() -> void:
	save_data = DEFAULT_SAVE_DATA.duplicate(true) 
	save_game()


func get_plant_limit_cap() -> int:
	return int(save_data.get("plant_limit_cap", DEFAULT_SAVE_DATA["plant_limit_cap"]))


func set_plant_limit_cap(new_limit: int) -> void:
	save_data["plant_limit_cap"] = new_limit
	save_game()
