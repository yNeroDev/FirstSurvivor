extends Area2D
class_name HurtBoxComponent

signal hit

@export var health_component: Node
#@export var floating_text_scene: PackedScene
var floating_text_scene = preload("res://scenes/UI/floating_text.tscn") #the same

func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not other_area is HitBoxComponent:
		return
	
	if health_component == null:
		return

	var hitbox_component = other_area as HitBoxComponent
	health_component.damage(hitbox_component.damage)

	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text) #no defensive programming
	
	floating_text.global_position = global_position + Vector2.UP * 16
	
	var format_string = "%0.1f" #set damage number to x.x
	if round(hitbox_component.damage) == hitbox_component.damage:
		format_string = "%0.0f" #and to x. if x.0
	floating_text.start(format_string % hitbox_component.damage)
	
	hit.emit()
