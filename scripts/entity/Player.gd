extends CharacterBody2D
class_name Lich

@export var MaxHealth:int = 50
@export var Speed:float = 300.0
@export_range(0.0, 1.0) var PunchDrawnPenalty:float = 0.8

@export var MaxWindupTime:float = 2.5
@export var Damage:int = 5

@onready var step_pool = $StepPool
@onready var punch_meat_pool = $PunchMeatPool
@onready var punch_wiff = $PunchWiff
@onready var punch_people_pool = $PunchPeoplePool

var time_since_held:float = 0
var mouse_pressed:bool = false
var ball:CharacterBody2D
var health
var enemies_in_way:Array = []

func _ready():
	health = MaxHealth
	$GraphicsController.character = 0
	$GraphicsController.generate_character()
##

func _input(event):
	if event is InputEventMouseButton:
		if event.is_released():
			mouse_pressed = false
			punch(global_position.direction_to(get_global_mouse_position()).normalized())
		elif event.is_pressed():
			mouse_pressed = true
			time_since_held = 0
		##
	##
##

func punch(dir_from_player_to_mouse):
	if ball == null and len(enemies_in_way) == 0:
		punch_wiff.play_random_sound()
		return
	##
	
	if ball != null:
		ball.smacked(dir_from_player_to_mouse, clampf(time_since_held / MaxWindupTime, 0, 1))
		punch_meat_pool.play_random_sound()
	##
	
	if len(enemies_in_way) > 0 and ball == null:
		punch_people_pool.play_random_sound()
	##
	
	for e in enemies_in_way:
		e.take_damage(Damage)
		if health < MaxHealth:
			health += Damage
			if health > MaxHealth:
				health = MaxHealth
			##
		##
	##
##

func _process(delta):
	if mouse_pressed:
		time_since_held += delta
	##
##

func _physics_process(delta):
	$Rotator.look_at(get_global_mouse_position())
	
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
	
	#if (x_dir or y_dir) and step_pool.is_playing() == false:
		#step_pool.play_random_sound()
	##
	
	move_and_slide()
##

func _on_entity_punch_detector_body_entered(body):
	if body is FleshBall2D:
		ball = body
	else:
		enemies_in_way.append(body)
	##
##

func _on_entity_punch_detector_body_exited(body):
	if body is FleshBall2D:
		ball = null
	else:
		enemies_in_way.remove_at(enemies_in_way.find(body))
	##
##

func take_damage(dmg):
	health -= dmg
	print("ow! ", health, "/50")
	if health <= 0:
		# spawn death particles
		# kill
		GlobalSignals.emit_signal("player_out_of_health")
		process_mode = Node.PROCESS_MODE_DISABLED
	##
##
