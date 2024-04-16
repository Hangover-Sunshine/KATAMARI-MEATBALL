extends Entity
class_name Cultist

@export var MovementSpeed:float = 300.0
@export var ChaseSpeed:float = 365.0

@onready var travel_brain:NavigationAgent2D = $TravelBrain
@onready var path_requery_timer = $PathRequeryTimer

# TODO: remove the $"..."
@onready var fleshball = $"../FleshBall"

var setup_finished:bool = false

var jump_into_ball:bool = false

# Not-Ball
var found_target:bool = false
var converting:bool = false
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
	if setup_finished == false or jump_into_ball or converting:
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
	
	velocity = global_position.direction_to(travel_brain.get_next_path_position()) * travel_speed
	move_and_slide()
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
		if body is Civilian and body.being_converted_by() == null and body.being_escorted_by() == null:
			found_target = true
			civvy = body
			travel_brain.target_position = civvy.global_position
		##
	##
##

func _on_sight_body_exited(body):
	if body == civvy:
		found_target = false
		civvy = null
		converting = false
		path_requery_timer.stop()
	##
##

func _on_conversion_zone_body_entered(body):
	if body == civvy:
		if civvy.being_converted_by() == null:
			civvy.begin_conversion_by(self)
			path_requery_timer.stop()
			velocity = Vector2.ZERO
			converting = true
		else:
			_on_sight_body_exited(body) # just call this as a clean-up method lmao
		##
	##
##

func _on_path_requery_timer_timeout():
	path_requery_timer.start(0.25)
	
	if civvy:
		travel_brain.target_position = civvy.global_position
	##
##

func take_damage(_dmg):
	if civvy:
		civvy.stop_converting()
	##
	queue_free()
##
