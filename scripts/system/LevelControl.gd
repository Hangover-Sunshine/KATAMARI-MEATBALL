extends Node2D
class_name LevelControl

@onready var pause_layer = $PauseLayer

func _ready():
	GlobalSignals.connect("scene_loaded", _scene_loaded)
	GlobalSignals.connect("unpause", _unpause)
##

func _unpause():
	get_tree().paused = false
	pause_layer.hide()
##

func _scene_loaded(new_scene:String):
	if new_scene != name:
		queue_free()
	##
##

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = !get_tree().paused
		if pause_layer.visible:
			pause_layer.hide()
		else:
			pause_layer.show()
		##w
	##
##
