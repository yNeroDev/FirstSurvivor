extends CanvasLayer

signal transitioned_halfway

var skip_emit = false

func transition():
	$AnimationPlayer.play("default")
	await transitioned_halfway
	$AnimationPlayer.play_backwards("default")

func emit_transitioned_halfway():
	if skip_emit:
		skip_emit = false
		return # ignores the second emitting of the halfway transition
	transitioned_halfway.emit()

