extends CanvasLayer

var options_scene = preload("res://scenes/UI/options_menu.tscn")
var meta_scene = preload("res://scenes/UI/meta_menu.tscn")

func _ready():
	%PlayButton.pressed.connect(on_play_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	%MetaButton.pressed.connect(on_meta_pressed)
	
func on_play_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/Main/main.tscn")
	
func on_options_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_button_pressed.connect(on_options_closed.bind(options_instance))
	
func on_quit_pressed():
	get_tree().quit()

func on_meta_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/UI/meta_menu.tscn")
	
func on_options_closed(options_instance: Node):
	options_instance.queue_free() #frees the options menu and the behind hidden start menu appears again
	
