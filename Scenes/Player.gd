extends CharacterBody2D

const XP_DATABASE = "res://Score/Database.json"
const SAVE_FILE_PATH = "user://savegame.json"
const MAX_LEVEL = 4

var XP_Table_Data = {}
var Level : int = 1:
	set(value):
		Level = value
		%Label.text = str(value)

var rpgClass
var current_xp = 0:
	set(value):
		current_xp = value
		var max_xp = get_max_xp_at(Level)

		if current_xp >= max_xp and Level < MAX_LEVEL:
			Level += 1
			current_xp -= max_xp
		elif Level == MAX_LEVEL:
			current_xp = 0

		var total = min((XP_Table_Data[str(Level)]["total"] + current_xp),
						XP_Table_Data[str(MAX_LEVEL)]["total"])
		%TotalXP.text = str(total)

		%ProgressBar.max_value = get_max_xp_at(Level)
		%ProgressBar.value = current_xp

var HP : int :
	set(value):
		HP = value
		%HP.text = str(value)

var Vitality : int :
	set(value):
		Vitality = value
		HP += 10 * (Vitality/4)
		%Vitality.text = str(value)

var Agility : int :
	set(value):
		Agility = value
		%Agility.text = str(value)

var Defense : int :
	set(value):
		Defense = value
		%Defense.text = str(value)

func _ready():
	XP_Table_Data = get_xp_data()
	print(XP_Table_Data)
	load_game_data()
	rpgClass = Knight.new()
	rpgClass.set_base_stat(self)

func get_xp_data() -> Dictionary:
	var file = FileAccess.open(XP_DATABASE, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	return data

func get_max_xp_at(level):
	return XP_Table_Data[str(level)]["need"]

func _on_gain_xp_pressed():
	current_xp += 100

func add_xp(amount: int):
	current_xp += amount

func save_game_data():
	var save_data = {
		"level": Level,
		"current_xp": current_xp,
		"hp": HP,
		"vitality": Vitality,
		"agility": Agility,
		"defense": Defense
	}

	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_string(to_json(save_data))  # Fixed: Use JSON class

func load_game_data():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if data.error == OK:
			var save_data = data.result
			Level = save_data.get("level", 1)
			current_xp = save_data.get("current_xp", 0)
			HP = save_data.get("hp", 100)  # Default HP value
			Vitality = save_data.get("vitality", 0)
			Agility = save_data.get("agility", 0)
			Defense = save_data.get("defense", 0)

func to_json(data: Dictionary) -> String:
	var json = JSON.new()
	var json_string = json.print(data)
	return json_string
