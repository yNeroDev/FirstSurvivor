extends CharacterBody2D


@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilites
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent

var number_colliding_bodies = 0
var base_speed = 0

func _ready():
	base_speed = velocity_component.max_speed
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()

func _process(delta):
	var movement_vector = get_movement_vector() #change here for movement settings: get_movement_vector_android()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
		
	if movement_vector.y != 0 || movement_vector.x != 0: 
		animation_player.play("walk")
	else:
		animation_player.play("RESET") 
		
	if movement_vector.x > 0:
		visuals.scale.x = 1
	if movement_vector.x < 0:
		visuals.scale.x = -1 
	#var move_sign = sign(velocity.x)
	#if move_sign != 0:
	#	visuals.scale = Vector2(-move_sign, 1), also possible >:


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") -  Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") -  Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)

func get_movement_vector_android(): #essentially making it work for andriod touchscreens
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var player_position = get_global_position()  # Assuming this script is attached to the player node
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - player_position).normalized()
		return direction
	else:
		return Vector2.ZERO
	
func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return #If the clock is ticking, we return and don't get damaged
	health_component.damage(1)
	damage_interval_timer.start() #Start our .5 seconds immunity
	
func update_health_display():
	health_bar.value = health_component.get_health_percent() 
	#set HealthBar value from 0 to 1 from HealthComponent Script
	
func on_body_entered(other_body: Node2D): #Enemy entering character body
	number_colliding_bodies += 1
	check_deal_damage()
	
func on_body_exited(other_body: Node2D): #Enemy exiting character body
	number_colliding_bodies -= 1
	
	
func on_damage_interval_timer_timeout():
	check_deal_damage() #Calls the damage check each time the clock runs out

func on_health_changed():
	GameEvents.emit_player_damaged()
	update_health_display() #set display once health changed emitted from HealthComponent
	$HitRandomAudioPlayerComponent.play_random()

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var _ability = ability_upgrade as Ability #not used
		abilities.add_child(ability_upgrade.ability_controller_scene.instantiate()) 
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .1)
	
