extends Camera2D

@export var Player:CharacterBody2D
@export var Target:FleshBall2D
@export var MaxOffset:float = 200
@export_range(0.001, 1) var ZoomSpeed:float = 0.2

var new_zoom:Vector2

func _ready():
	GlobalSignals.connect("ball_level_changed", _ball_level_changed)
	new_zoom = zoom
##

func _ball_level_changed(lvl:int):
	if lvl == 0:
		new_zoom.x = 1
		new_zoom.y = 1
	elif lvl == 1:
		new_zoom.x = 0.6
		new_zoom.y = 0.6
	else:
		new_zoom.x = 0.2
		new_zoom.y = 0.2
	##
##

func _process(delta):
	var distance = Player.global_position.distance_to(Target.global_position)
	
	# bias the camera's position towards the ball, starting from the player's position
	var dir:Vector2 = Player.global_position.direction_to(Target.global_position)
	var noffset:Vector2 = dir * clampf((distance / 2), 0, MaxOffset)
	
	global_position = Player.global_position + noffset
	
	if zoom != new_zoom:
		zoom = lerp(zoom, new_zoom, ZoomSpeed * delta)
	##
##
