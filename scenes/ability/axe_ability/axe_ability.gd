extends Node2D

const MAX_RADIUS = 100

@onready var hitbox_component = $HitBoxComponent # referenced so we can call it in the axe_ability_controller

var starting_angle = Vector2.RIGHT
var root_position = Vector2.ZERO

func _ready():
	starting_angle = Vector2.RIGHT.rotated(randf_range(0, TAU)) #randomized starting angle of axe
	root_position = set_center_of_circle()
	
	var tween = create_tween() #"in-betweening" creating smooth transitions between two values
	tween.tween_method(tween_method, 0., 2., 3) 
	#from, to, duration | those values will be passed to the func
	tween.tween_callback(queue_free) #free axe when tweening is done.
	
func tween_method(rotations: float):
	var percent = rotations / 2 #percent because 2 s tween / 2 = 1
	var current_radius = percent * MAX_RADIUS #length for vector
	var current_direction = starting_angle.rotated(rotations * -TAU) #unit vector rotated 360°
	

	global_position = root_position + (current_radius * current_direction) 
	#radius 0 to 100, direction (1, 0) to (1, 0) with two counter clockwise rotations
	
func set_center_of_circle():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	return player.global_position


