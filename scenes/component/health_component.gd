extends Node
class_name HealthComponent

signal died #signals that the entity holding this component died
signal health_changed

@export var max_health: float = 10
var current_health

func _ready():
	current_health = max_health
	
func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0) #cant go below 0
	health_changed.emit() #emits that the health changed, wont work when entity can heal
	Callable(check_death).call_deferred()
	
func get_health_percent(): #helper function for HealthBar
	if max_health <= 0:
		return 0 #cant go below 0
	return min(current_health / max_health, 1) #returns health from 0 to 1


func check_death():
	if current_health == 0:
		died.emit() #emits that we died, when health is 0
		owner.queue_free() #deletes the Node that holds the HealthComponent, e.g. player
