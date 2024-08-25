extends Camera2D

var target_position = Vector2.ZERO

func _ready():
	make_current()

func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20)) #randomly sets the lerp value (linear interpolation) to 0.15351827 why do we need Euler? Probably to set the value uncluding the delta there, somehow.

func acquire_target():
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		target_position = player.global_position
# assings target position only when the player exists
