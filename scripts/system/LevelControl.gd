extends Node2D
class_name LevelControl

@onready var pause_layer = $PauseLayer
@onready var player = $Game/Player
@onready var play_area = $Game/PlayArea

func _ready():
	GlobalSignals.connect("scene_loaded", _scene_loaded)
	GlobalSignals.connect("unpause", _unpause)
	
	LWSave.Prefs["game"] = {}
	
	# play information
	LWSave.Prefs["game"]["cult_roll"] = 0
	LWSave.Prefs["game"]["hero_roll"] = 0
	LWSave.Prefs["game"]["civy_roll"] = 0
	LWSave.Prefs["game"]["cult_punch"] = 0
	LWSave.Prefs["game"]["hero_punch"] = 0
	LWSave.Prefs["game"]["civy_punch"] = 0
	LWSave.Prefs["game"]["time"] = 0
	LWSave.Prefs["game"]["ball"] = 0
	LWSave.Prefs["game"]["ball_real"] = $Game/MysteryFleshBall.current_consumption
	LWSave.Prefs["game"]["winner"] = false
##

func _unpause():
	player.just_unpaused = true
	get_tree().paused = false
	pause_layer.hide()
	play_area.process_mode = Node.PROCESS_MODE_INHERIT
##

func _scene_loaded(new_scene:String):
	if new_scene != name:
		queue_free()
	##
##

func _process(delta):
	# only add to the timer if the game isn't paused
	if get_tree().paused == false:
		LWSave.Prefs["game"]["time"] += delta
	##
	
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = !get_tree().paused
		if pause_layer.visible:
			pause_layer.hide()
		else:
			pause_layer.show()
		##
		player.just_unpaused = true
	##
##
