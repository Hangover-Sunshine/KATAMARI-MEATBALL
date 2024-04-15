extends CharacterBody2D
class_name Cultist

@export var MovementSpeed:float = 300.0
@export var ConsumptionAddition:float = 5.5

@onready var travel_brain:NavigationAgent2D = $TravelBrain

# TODO: in the spawn system, pass this in -- for now, hardcoded
@onready var fleshball = $"../FleshBall"

var setup_finished:bool = false

var jump_into_ball:bool = false
var ball_rolled_over:bool = false

#TODO: replace this
var jib_time_to_free:float = 4

func _ready():
	# Godot's start goes from bottom of tree to top, so should be good to go by this point!
	$CultistSprite.character = 1
	$CultistSprite.generate_character()
	call_deferred("_await_set")
##

func _await_set():
	await get_tree().physics_frame
	set_target_position()
	setup_finished = true
##

func set_target_position():
	travel_brain.target_position = fleshball.global_position
##

func _process(delta):
	if jump_into_ball:
		jib_time_to_free -= delta
		if jib_time_to_free <= 0:
			queue_free()
		##
	##
	
	if ball_rolled_over:
		# spawn a flesh/blood particle, disappear
		queue_free()
	##
##

func _physics_process(delta):
	if jump_into_ball or ball_rolled_over:
		return
	##
	
	if setup_finished and travel_brain.is_navigation_finished()\
		and global_position.distance_to(fleshball.global_position) > 150:
		travel_brain.target_position = fleshball.global_position
	##
	
	velocity = global_position.direction_to(travel_brain.get_next_path_position()) * MovementSpeed
	move_and_slide()
##

func get_consumption_addition():
	return ConsumptionAddition
##

func rolled_over():
	ball_rolled_over = true
##

func get_absorbed():
	jump_into_ball = true
##
