extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent

func _ready():
	$HurtBoxComponent.hit.connect(on_hit)


func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self) #self referring to the current class instance

	var move_sign = sign(velocity.x) #used to change the viewing direction of those monsters
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign, 1)

func on_hit():
	$HitRandomAudioPlayerComponent.play_random()
