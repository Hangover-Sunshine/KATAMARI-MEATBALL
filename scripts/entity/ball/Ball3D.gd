extends Node3D

@export var MaxSpinSpeed:float = 5.0

@onready var model = $Model

var max_speed:float
var velocity:Vector2

var dist_to_maintain:float

var material
var curr_level:int = 0

func _ready():
	dist_to_maintain = $Camera3D.global_position.distance_to(model.global_position)
	material = model.get_active_material(0)
##

func set_ball_scale(size, decrease):
	var lod = 0
	
	while size > 100:
		lod += 1
		size -= 100
	##
	
	var rod = (size / 100)
	var new_rad = lod + rod
	
	if new_rad >= 2.65:
		return
	##
	
	model.mesh.radius = new_rad
	model.mesh.height = 2 * model.mesh.radius
	
	$Camera3D.global_position = Vector3(0, 1, 0) * (new_rad + dist_to_maintain)
##

func get_ball_scale():
	return model.scale.x
##

func _physics_process(delta):
	var x_rads = MaxSpinSpeed * (velocity.x / max_speed)
	var y_rads = MaxSpinSpeed * (velocity.y / max_speed)
	model.rotate_x(x_rads * sign(velocity.x) * delta)
	# atan2 or angle or whatever
	model.rotate_z(y_rads * sign(velocity.y) * delta)
##
