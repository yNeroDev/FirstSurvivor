extends CanvasLayer

@onready var progress_bar = $MarginContainer/ProgressBar

@export var experience_manager: Node
@export var fill_speed: float = 5.0

var target_value: float = 0.0

func _ready():
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)

func on_experience_updated(current_experience: float, target_experience: float):
	var percent = current_experience / target_experience
	set_xp(percent)

func set_xp(new_value: float):
	target_value = new_value

func _process(delta: float):
	if progress_bar.value != target_value:
		progress_bar.value = lerp(progress_bar.value, target_value, fill_speed * delta)

