extends Node

@export var axe_ability_scene: PackedScene

var base_damage = 5
var additional_damage_percent = 1

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return #referencing and safety
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground_layer == null:
		return #referencing and safety
		
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground_layer.add_child(axe_instance) #get the axe into the game
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = base_damage * additional_damage_percent #getting the damage of the axe_instance hitbox_component and setting it to the damage

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "axe_damage":
		additional_damage_percent = 1 + (current_upgrades["axe_damage"]["quantity"] * .1)
		
