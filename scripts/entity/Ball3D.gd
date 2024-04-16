extends Node3D

@onready var model = $Model

var velocity:Vector2

func _physics_process(delta):
	model.rotate_x(5 * sign(velocity.x) * delta)
	model.rotate_z(5 * sign(velocity.y) * delta)
##
