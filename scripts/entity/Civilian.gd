extends Entity
class_name Civilian

@export var MovementSpeed:float = 350.0
@export_range(0.1, 0.8) var EscortSpeedPenality:float = 0.5
@export var WaitTime:Vector2 = Vector2(0.8, 1.8)
@export var WanderTime:Vector2 = Vector2(1.5, 4)

@export_group("Conversion")
@export var ConversionSpeed:float = 3.5
@export var ConversionAmount:Vector2 = Vector2(20.0, 30.0)

@export_group("Escape")
@export var TimeToEscape:float = 2.5
####

@onready var destination_wait_timer = $DestinationWaitTimer
@onready var travel_brain:NavigationAgent2D = $TravelBrain
@onready var progress_to_conversion = $ProgressToConversion
@onready var wander_timer = $WanderTimer

var wander_dir:Vector2

var waiting_done:bool = false

var being_converted:bool = false
var cultist_converting:Cultist

var freeing_self:bool = false
var being_escorted:bool = false
var escort_under_attack:bool = false
var escort:Adventurer

func _ready():
	$GraphicsControl.character = 5
	$GraphicsControl.generate_character()
	
	wander_timer.start(randf_range(WanderTime.x, WanderTime.y))
	wander_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	
	# swap
	if WaitTime.x > WaitTime.y:
		var t = WaitTime.x
		WaitTime.x = WaitTime.y
		WaitTime.y = t
	##
	
	# swap
	if ConversionAmount.x > ConversionAmount.y:
		var t = ConversionAmount.x
		ConversionAmount.x = ConversionAmount.y
		ConversionAmount.y = t
	##
##

func set_target_position(pos:Vector2):
	travel_brain.target_position = pos
	destination_wait_timer.stop()
##

func _physics_process(delta):
	if being_converted or escort_under_attack or freeing_self:
		return
	##
	
	if being_escorted:
		if travel_brain.is_navigation_finished():
			if being_escorted:
				freeing_self = true
				destination_wait_timer.start(TimeToEscape)
				return
			##
			
			if destination_wait_timer.is_stopped():
				var wait = randf_range(WaitTime.x, WaitTime.y)
				destination_wait_timer.start(wait)
			##
			return
		##
		var movement = MovementSpeed * EscortSpeedPenality
		velocity = global_position.direction_to(travel_brain.get_next_path_position()) * movement
	else:
		velocity = wander_dir * MovementSpeed
	##
	
	move_and_slide()
##

func _on_destination_wait_timer_timeout():
	if being_converted:
		progress_to_conversion.value += randf_range(ConversionAmount.x, ConversionAmount.y)
		
		if progress_to_conversion.value >= 100:
			GlobalSignals.emit_signal("convert_citizen_to_cultist", self)
		else:
			destination_wait_timer.start(ConversionSpeed)
		##
	elif freeing_self:
		# TODO: put things here
		GlobalSignals.emit_signal("entity_removed")
		if escort != null:
			escort.free_from_help()
		##
		queue_free()
	else:
		# pick a new direction and go in it for X seconds
		wander_timer.start(randf_range(WanderTime.x, WanderTime.y))
		wander_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	##
##

func begin_conversion_by(cultist):
	velocity = Vector2.ZERO
	being_converted = true
	cultist_converting = cultist
	progress_to_conversion.value = 0
	destination_wait_timer.start(ConversionSpeed)
##

func stop_converting():
	being_converted = false
	destination_wait_timer.stop()
	if cultist_converting != null:
		cultist_converting.civvy = null
	cultist_converting = null
	progress_to_conversion.value = 0
##

func being_converted_by() -> Cultist:
	return cultist_converting
##

func start_escorting(adventurer:Adventurer):
	escort = adventurer
	being_escorted = true
	GlobalSignals.emit_signal("request_escort_point", self, adventurer)
##

func stop_escorting():
	being_escorted = false
	escort_under_attack = false
	if escort != null:
		escort.target = null
	escort = null
##

func being_escorted_by() -> Adventurer:
	return escort
##

func rolled_over():
	if being_converted_by() != null:
		stop_converting()
	elif being_escorted_by() != null:
		stop_escorting()
	##
	GlobalSignals.emit_signal("entity_removed")
	# spawn particle
	
	# spawn sound effect at location
	
	# die
	queue_free()
##

func take_damage(dmg):
	if being_converted_by() != null:
		stop_converting()
	elif being_escorted_by() != null:
		stop_escorting()
	##
	GlobalSignals.emit_signal("entity_removed")
	queue_free()
##
