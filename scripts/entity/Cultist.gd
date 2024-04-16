extends CharacterBody2D
class_name Cultist

@export var MovementSpeed:float = 300.0
@export var ChaseSpeed:float = 365.0
@export var ConsumptionAddition:float = 5.5

@onready var travel_brain:NavigationAgent2D = $TravelBrain
@onready var path_requery_timer = $PathRequeryTimer

# TODO: in the spawn system, pass this in -- for now, hardcoded
@onready var fleshball = $"../FleshBall"

var setup_finished:bool = false

var jump_into_ball:bool = false

# Not-Ball
var found_target:bool = false
var converting:bool = false
var adventurer
var civvy:Civilian

#TODO: replace this
var jib_time_to_free:float = 4

func _ready():
	# Godot's start goes from bottom of tree to top, so should be good to go by this point!
	$CultistSprite.character = 1
	$CultistSprite.generate_character()
	call_deferred("_await_set")
##

func load_from_civvy(civvy:Civilian):
	# TODO: preserve head/hands from civvy self -- for now, don't care
	pass
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
##

func _physics_process(delta):
	if setup_finished == false or jump_into_ball:
		return
	##
	
	var travel_speed:float
	if found_target == false:
		if travel_brain.is_navigation_finished()\
			and global_position.distance_to(fleshball.global_position) > 150:
			travel_brain.target_position = fleshball.global_position
		##
		travel_speed = MovementSpeed
	else:
		if converting == false and travel_brain.is_navigation_finished():
			path_requery_timer.start(0.5)
			travel_brain.target_position = civvy.global_position
		##
		travel_speed = ChaseSpeed
	##
	
	if not converting:
		velocity = global_position.direction_to(travel_brain.get_next_path_position()) * travel_speed
		move_and_slide()
	##
##

func get_consumption_addition():
	return ConsumptionAddition
##

func rolled_over():
	queue_free()
##

func get_absorbed():
	jump_into_ball = true
	# once jumping in, they're done -- ignore the world you mindless heathen
	$ConversionZone.queue_free()
	$Sight.queue_free()
##

func _on_sight_body_entered(body):
	if found_target == false:
		found_target = true
		if body is Civilian and body.being_converted_by() == null:
			civvy = body
		##
	##
##

func _on_sight_body_exited(body):
	found_target = false
	adventurer = null
	civvy = null
	converting = false
	path_requery_timer.stop()
##

func _on_conversion_zone_body_entered(body):
	if body == civvy:
		if civvy.being_converted_by() == null:
			_on_sight_body_exited(body) # just call this as a clean-up method lmao
		else:
			civvy.begin_conversion_by(self)
			path_requery_timer.stop()
			velocity = Vector2.ZERO
			converting = true
		##
	##
##

func _on_path_requery_timer_timeout():
	path_requery_timer.start(0.5)
	
	if civvy:
		travel_brain.target_position = civvy.global_position
	else:
		travel_brain.target_position = adventurer.global_position
	##
##
