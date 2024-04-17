extends Node3D

@export var MaxSpinSpeed:float = 5.0
@export var Tex1:Texture2D
@export var Tex2:Texture2D
@export var Tex3:Texture2D

@onready var model = $Model

var max_speed:float
var velocity:Vector2

var dist_to_maintain:float

func _ready():
	dist_to_maintain = $Camera3D.global_position.distance_to(model.global_position) - min_ball_scale()
##

func set_ball_scale(size):
	model.scale.x = size
	model.scale.y = size
	model.scale.z = size
	$Camera3D.global_position = size + dist_to_maintain
	
	# swap textures here on different sizes
##

func get_ball_scale():
	return model.scale.x
##

func min_ball_scale() -> float:
	return 1.65
##

func _physics_process(delta):
	var x_rads = MaxSpinSpeed * (velocity.x / max_speed)
	var y_rads = MaxSpinSpeed * (velocity.y / max_speed)
	model.rotate_x(x_rads * sign(velocity.x) * delta)
	model.rotate_z(y_rads * sign(velocity.y) * delta)
##
