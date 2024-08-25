extends Control

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel

var disabled = false #for those spammers wanting more upgrades

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	
func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout #asynchronous programming, stop func until timeout signal emitted
	modulate = Color.WHITE
	$AnimationPlayer.play("in")
	
func discard_card():
	$AnimationPlayer.play("discard")

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description

func select_card():
	disabled = true
	$SelectedAnimationPlayer.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card == self:
			continue
		other_card.discard_card()
		
	await $SelectedAnimationPlayer.animation_finished
	selected.emit() #tells the upgrade screen we selected something

func on_mouse_entered():
	if disabled:
		return
	$HoverAnimationPlayer.play("hover")

func on_mouse_exited():
	$HoverAnimationPlayer.play("RESET")

func on_gui_input(event: InputEvent):
	if disabled:
		return
		
	if event.is_action_pressed("left_click"):
		select_card()
