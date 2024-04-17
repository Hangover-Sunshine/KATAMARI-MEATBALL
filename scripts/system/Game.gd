extends Node2D

## Maximum number of spawnable entities.
@export var MaxEntities:int = 200
## How much to offset the time up by.
@export var SpawnTimeOffset:Vector2 = Vector2(0.5, 1.5)
## Range of the number of entities to spawn when the timer goes off.
@export var SpawnEntityRange:Vector2i = Vector2i(4, 10)

@export_group("References")
## Reference to the player
@export var Player:Lich
## Reference to the camera
@export var Camera:Camera2D

@onready var spawn_timer = $Details/SpawnTimer

var curr_num_of_entities:int = 0

var bdmg_timer:float = 1
var pdmg_timer:float = 2

func _ready():
	GlobalSignals.connect("player_out_of_health", _player_out_of_health)
	GlobalSignals.connect("ball_level_changed", _ball_level_changed)
	GlobalSignals.connect("ball_escaped", _ball_escaped)
	spawn_timer.start(2 + randf_range(SpawnTimeOffset.x, SpawnTimeOffset.y))
##

func _process(delta):
	if bdmg_timer <= 0:
		if Input.is_key_pressed(KEY_P):
			$MysteryFleshBall.take_damage(-100)
			bdmg_timer = 1
		elif Input.is_key_pressed(KEY_O):
			$MysteryFleshBall.take_damage(10)
			bdmg_timer = 1
		##
	else:
		bdmg_timer -= delta
	##
	
	if pdmg_timer <= 0:
		if Input.is_key_pressed(KEY_L):
			Player.take_damage(10)
			pdmg_timer = 2
		elif Input.is_key_pressed(KEY_K):
			Player.take_damage(-10)
			pdmg_timer = 2
		##
	else:
		pdmg_timer -= delta
	##
##

func _on_spawn_timer_timeout():
	spawn_timer.start(2 + randf_range(SpawnTimeOffset.x, SpawnTimeOffset.y))
##

func _player_out_of_health():
	print("here")
	LWSave.Prefs["winner"] = false
	GlobalSignals.emit_signal("load_scene", "Menus/Game_Over")
##

func _ball_level_changed(lvl:int):
	pass
##

func _ball_escaped():
	pass
##
