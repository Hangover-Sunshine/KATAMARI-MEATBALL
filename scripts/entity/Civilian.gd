extends CharacterBody2D

@export var MovementSpeed:float = 350.0
@export var ConsumptionAddition:float = 10.0

@onready var travel_brain:NavigationAgent2D = $TravelBrain
var waiting_done:bool = false

func _ready():
	$GraphicsControl.character = 5
	$GraphicsControl.generate_character()
	call_deferred("_await_physics_frame")
##

func _await_physics_frame():
	await get_tree().physics_frame
	waiting_done = true
##

func _physics_process(delta):
	if waiting_done and travel_brain.is_navigation_finished():
		pass
	##
	
	velocity = global_position.direction_to(travel_brain.get_next_path_position()) * MovementSpeed
	move_and_slide()
##
