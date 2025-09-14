extends Node
class_name SaveManager

const ENCRYPTION_KEY := "my_super_secret_key_32bytes!" 
var save_path: String
var save_data: Dictionary = {
	"plant_unlock": [ { "peashooter": ["tier1"] } ],
	"shop_upgrade": [ {} ],
	"level_complete": [ {} ]
}

func _ready() -> void:
	var folder_path = OS.get_user_data_dir().path_join("MyGameSave")
	DirAccess.make_dir_recursive_absolute(folder_path)
	save_path = folder_path.path_join("SaveFile.dat")
	if FileAccess.file_exists(save_path):
		load_game()
	else:
		save_game() 
		

func save_game() -> void:
	var json_str := JSON.stringify(save_data, "\t") # formatted for readability before encryption

	var enc := FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, ENCRYPTION_KEY)
	if enc:
		enc.store_string(json_str)
		enc.close()
	else:
		push_error("Failed to open save file for writing: " + save_path)


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
			save_game()
		print(content)
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


func unlock_tier(plant_name: String, tier_name: String) -> void:
	for plant_entry in save_data.get("plant_unlock", []):
		if plant_name in plant_entry:
			var tiers: Array = plant_entry[plant_name]
			if tier_name not in tiers:
				tiers.append(tier_name)
				save_game()
			return 
