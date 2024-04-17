extends Node3D

@export var MaxSpinSpeed:float = 5.0
@export var Tex1:Texture2D
@export var Tex2:Texture2D
@export var Tex3:Texture2D

@onready var model = $Model

var max_speed:float
var velocity:Vector2

var dist_to_maintain:float

var material
var curr_level:int = 0

func _ready():
	dist_to_maintain = $Camera3D.global_position.distance_to(model.global_position) - min_ball_scale()
	material = model.get_active_material(0)
##

func set_ball_scale(size):
	var lod = 1
	while size > 100:
		lod += 1
		size -= 100
	##
	
	var rod = (size / 100)
	
	model.scale.x = lod + rod
	model.scale.y = lod + rod
	model.scale.z = lod + rod
	$Camera3D.global_position = Vector3(0, 1, 0) * (lod + rod + dist_to_maintain)
	
	# swap textures here on different sizes
	if curr_level != 0 and model.scale.x < 12:
		material.albedo_texture = Tex1
		model.set_surface_override_material(0, material)
		curr_level = 0
		GlobalSignals.emit_signal("ball_level_changed", 0)
	elif curr_level != 1 and model.scale.x >= 12 and model.scale.x <= 20:
		material.albedo_texture = Tex2
		model.set_surface_override_material(0, material)
		curr_level = 1
		GlobalSignals.emit_signal("ball_level_changed", 1)
	elif curr_level != 2 and model.scale.x > 20:
		material.albedo_texture = Tex3
		model.set_surface_override_material(0, material)
		curr_level = 2
		GlobalSignals.emit_signal("ball_level_changed", 2)
	##
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
	# atan2 or angle or whatever
	model.rotate_z(y_rads * sign(velocity.y) * delta)
##
