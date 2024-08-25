extends Node

#@export var upgrade_pool: Array[AbilityUpgrade] doesn't work anymore as we add buffs
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {} #initializing the current_upgrades as an emtpy dictionary
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")

func _ready():
	upgrade_pool.add_item(upgrade_axe, 10) #greater weight, greater probability
	upgrade_pool.add_item(upgrade_sword_rate, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	upgrade_pool.add_item(upgrade_player_speed, 5)
	
	experience_manager.level_up.connect(on_level_up) 
	
	
func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id) #checks in dictionary, if it has resources id (referenced through ability_upgrade.gd by class_name)
	if !has_upgrade: #if it does not have upgrade if the chosen id
		current_upgrades[upgrade.id] = { #creates a nested dictionary with [upgrade.id] as the first dictionary
			"resource": upgrade, #->inheriting the second dictionary
			"quantity": 1
		}
		
	else:
		current_upgrades[upgrade.id]["quantity"] += 1 #else just add the quantity

	if upgrade.max_quantity > 0: #max qty of res, equal to max qty? remove.
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade) #remove axe from the upgrade_pool
			
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades) #emits the upgrade added signal for the ability controllers.

func update_upgrade_pool(chosen_upgrade: AbilityUpgrade): #adds new abilties to the pool
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 10)

func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 2:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades) as AbilityUpgrade #dont pick any upgrade that have already been chosen
		chosen_upgrades.append(chosen_upgrade) #pick a random upgrade from the pool and append it to the chosen_upgrades Array
		
	return chosen_upgrades
	
func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)

func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)

