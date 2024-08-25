extends Node

const SPAWN_RADIUS = 500

@export var basic_enemy_scene: PackedScene
@export var spider_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new() # create a new weighted table class > weighted_table.gd

func _ready():
	enemy_table.add_item(basic_enemy_scene, 50) #calls a function from the weighted_table.gd to add the rat with weight of 20
	base_spawn_time = timer.wait_time #set here for modularity. different wait timer will automatically updated
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position(): #gets enemy spawn
		
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO #when the player doesn't exist, spawn enemy at Vector.ZERO
	
	var spawn_position = Vector2.ZERO #initializing, safeguard, bug prevention
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU)) #randomly rotated unit vector
	
	for i in range(4): #shorthand is 'for i in 4:' | itereates 4 times. not using i is valid.
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS) #giving the vector a length
		
		var additional_check_offset = random_direction * 20
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1) 
		#creates parameters for the intersect_ray function, 1 is the terrain layer collision value
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters) 
		#creates a collision detecting ray and returns a dictionary of the collided object.
	
		if result.is_empty(): #intersect_ray returns an empty dictionary, if nothing intersects. So .is_empty is needed
			break #ends the loop 
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
		
	return spawn_position


func on_timer_timeout(): #tmeout signal function to spawn enemies
	timer.start() #One Shot off. Starts the timer by code after each timeout
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	var enemy_scene = enemy_table.pick_item() # calls func from weighted_table.gd to pick enemy
	var enemy = enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()

func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (.2 / 12) * arena_difficulty #factor for spawn decrease. 5s difficulty increase, 12 segments for 60s
	timer.wait_time = base_spawn_time - min(base_spawn_time, time_off) #more time_off, more spawn rate
	if timer.wait_time < 0.1:
		timer.wait_time = 0.1
	if arena_difficulty == 12:
		enemy_table.add_item(spider_enemy_scene, 10)
