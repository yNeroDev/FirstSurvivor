extends Node

const SAVE_FILE_PATH = "user://game.save" #shorthand for godot to point to the user directory on device.

var save_data: Dictionary = { 
	"meta_upgrade_currency" = 0,
	"meta_upgrades" = {}
} #initialising nested dictionary

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_collected)
	load_save_file()
	
func load_save_file():
	if not FileAccess.file_exists(SAVE_FILE_PATH): #if player did not save yet, fine. then we use just save_data dictionary
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ) #open file for reading
	save_data = file.get_var()


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)

func add_meta_upgrade(upgrade: MetaUpgrade):
	if not save_data["meta_upgrades"].has(upgrade.id): #if we dont have an entry for the upgrade we're passing in
		save_data["meta_upgrades"][upgrade.id] = { #then we set that entry with a default quantity of 0
			"quantity" = 0
		}
	
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1 #if we have tho, up quantity by 1
	save()

func get_upgrade_count(upgrade_id: String):
	if save_data["meta_upgrades"].has(upgrade_id):
		return save_data["meta_upgrades"][upgrade_id]["quantity"]
	return 0
	

func on_experience_collected(number: float):
	save_data["meta_upgrade_currency"] += number
