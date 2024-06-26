extends Entity
class_name Civilian

@export var MovementSpeed:float = 350.0
@export_range(0.1, 0.8) var EscortSpeedPenality:float = 0.5
@export var WaitTime:Vector2 = Vector2(0.8, 1.8)
@export var WanderTime:Vector2 = Vector2(1.5, 4)

## x/y = x range, w/z = y range
@export var FleePointOffset:Vector4 = Vector4(-10, 10, -10, 10)

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
var escort_under_attack:bool = false
var escort:Adventurer

var just_finished:bool = false

func _ready():
	$GraphicsControl.character = 5
	$GraphicsControl.generate_character()
	
	#wander_timer.start(randf_range(WanderTime.x, WanderTime.y))
	#wander_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	
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
	travel_brain.target_position = pos + Vector2(randf_range(FleePointOffset.x, FleePointOffset.y),
													randf_range(FleePointOffset.w, FleePointOffset.z))
	just_finished = false
##

func _physics_process(delta):
	if being_converted:
		return
	##
	
	if travel_brain.is_navigation_finished():
		if just_finished == false:
			just_finished = true
			destination_wait_timer.start(randf_range(WaitTime.x, WaitTime.y))
		##
		
		$GraphicsControl.play_idle()
		return
	##
	
	$GraphicsControl.play_waddle()
	velocity = global_position.direction_to(travel_brain.get_next_path_position()) * MovementSpeed
	
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
	else:
		# pick a new direction and go in it for X seconds
		#wander_timer.start(randf_range(WanderTime.x, WanderTime.y))
		#wander_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
		GlobalSignals.emit_signal("request_new_flee_point", self)
	##
	$GraphicsControl.play_idle()
##

func begin_conversion_by(cultist):
	velocity = Vector2.ZERO
	being_converted = true
	cultist_converting = cultist
	progress_to_conversion.value = 0
	wander_timer.stop()
	wander_dir = Vector2.ZERO
	destination_wait_timer.start(ConversionSpeed)
##

func stop_converting():
	being_converted = false
	destination_wait_timer.stop()
	if cultist_converting != null:
		cultist_converting.civvy = null
	cultist_converting = null
	progress_to_conversion.value = 0
	destination_wait_timer.start(randf_range(0.5, 1))
##

func being_converted_by() -> Cultist:
	return cultist_converting
##

func being_escorted_by() -> Adventurer:
	return escort
##

func at_end() -> bool:
	return travel_brain.is_navigation_finished()
##

func rolled_over():
	stop_converting()
	LWSave.Prefs["game"]["civy_roll"] += 1
	
	GlobalSignals.emit_signal("entity_removed", global_position, true)
	# spawn particle
	get_parent().dead(global_position)
	
	# die
	queue_free()
##

func take_damage(dmg):
	stop_converting()
	
	LWSave.Prefs["game"]["civy_punch"] += 1
	get_parent().dead(global_position)
	
	GlobalSignals.emit_signal("entity_removed", global_position, false)
	queue_free()
##

func _on_wander_timer_timeout():
	wander_dir = Vector2.ZERO
	var wait = randf_range(WaitTime.x, WaitTime.y)
	destination_wait_timer.start(wait)
##
