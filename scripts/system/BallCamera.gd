extends Camera2D

@export var Player:CharacterBody2D
@export var Target:CharacterBody2D
@export var MaxOffset:float = 200

func _process(delta):
	var distance = Player.global_position.distance_to(Target.global_position)
	
	# bias the camera's position towards the ball, starting from the player's position
	var dir:Vector2 = Player.global_position.direction_to(Target.global_position)
	var noffset:Vector2 = dir * clampf((distance / 2), 0, MaxOffset)
	
	global_position = Player.global_position + noffset
##
