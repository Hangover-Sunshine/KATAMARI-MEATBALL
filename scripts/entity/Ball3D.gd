extends Node3D

@export var MaxSpinSpeed:float = 5.0
@onready var model = $Model

var max_speed:float
var velocity:Vector2

func set_ball_scale(size):
	model.scale.x = size
	model.scale.y = size
	model.scale.z = size
##

func get_ball_scale():
	return model.scale.x
##

func min_ball_scale() -> float:
	return 1.7
##

func _physics_process(delta):
	var x_rads = MaxSpinSpeed * (velocity.x / max_speed)
	var y_rads = MaxSpinSpeed * (velocity.y / max_speed)
	model.rotate_x(x_rads * sign(velocity.x) * delta)
	model.rotate_z(y_rads * sign(velocity.y) * delta)
##
