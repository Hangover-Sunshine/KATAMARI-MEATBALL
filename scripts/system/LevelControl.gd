extends Node2D
class_name LevelControl

@onready var pause_layer = $PauseLayer

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = !get_tree().paused
		if pause_layer.visible:
			pause_layer.hide()
		else:
			pause_layer.show()
		##
	##
##
