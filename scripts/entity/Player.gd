extends CharacterBody2D
class_name Lich

@export var MaxHealth:int = 50
@export var Speed:float = 300.0
@export_range(0.0, 1.0) var PunchDrawnPenalty:float = 0.8

@export var MaxWindupTime:float = 2.5

var time_since_held:float = 0
var mouse_pressed:bool = false
var ball:CharacterBody2D
var health

func _ready():
	health = MaxHealth
	$GraphicsController.character = 0
	$GraphicsController.generate_character()
##

func _input(event):
	if event is InputEventMouseButton:
		if event.is_released():
			mouse_pressed = false
			apply_force(global_position.direction_to(get_global_mouse_position()).normalized())
		elif event.is_pressed():
			mouse_pressed = true
			time_since_held = 0
		##
	##
##

func apply_force(dir_from_player_to_mouse):
	if ball != null:
		ball.smacked(dir_from_player_to_mouse, clampf(time_since_held / MaxWindupTime, 0, 1))
	##
##

func _process(delta):
	if mouse_pressed:
		time_since_held += delta
	##
##

func _physics_process(delta):
	var x_dir = Input.get_axis("WalkLeft", "WalkRight")
	var y_dir = Input.get_axis("WalkUp", "WalkDown")
	
	if x_dir:
		velocity.x = x_dir * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
	##
	
	if y_dir:
		velocity.y = y_dir * Speed
	else:
		velocity.y = move_toward(velocity.y, 0, Speed)
	##
	
	move_and_slide()
##

func _on_ball_detector_body_entered(body):
	ball = body
##

func _on_ball_detector_body_exited(body):
	ball = null
##

func take_damage(dmg):
	health -= dmg
	print("ow! ", health, "/50")
##
