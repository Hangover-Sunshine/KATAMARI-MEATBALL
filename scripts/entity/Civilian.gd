extends CharacterBody2D
class_name Civilian

@export var MovementSpeed:float = 350.0
@export var ConsumptionAddition:float = 10.0
@export var WaitTime:Vector2 = Vector2(0.8, 1.8)

@export_group("Conversion")
@export var ConversionSpeed:float = 3.5
@export var ConversionAmount:Vector2 = Vector2(20.0, 30.0)
####

@onready var destination_wait_timer = $DestinationWaitTimer
@onready var travel_brain:NavigationAgent2D = $TravelBrain
@onready var progress_to_conversion = $ProgressToConversion

var waiting_done:bool = false
var being_converted:bool = false
var cultist_converting:Cultist

func _ready():
	$GraphicsControl.character = 5
	$GraphicsControl.generate_character()
	
	call_deferred("_await_physics_frame")
	
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

func _await_physics_frame():
	await get_tree().physics_frame
	waiting_done = true
	GlobalSignals.emit_signal("request_new_flee_point", self)
##

func set_target_position(pos:Vector2):
	travel_brain.target_position = pos
	destination_wait_timer.stop()
##

func _physics_process(delta):
	if being_converted:
		return
	##
	
	if travel_brain.is_navigation_finished():
		if destination_wait_timer.is_stopped():
			var wait = randf_range(WaitTime.x, WaitTime.y)
			destination_wait_timer.start(wait)
		##
		return
	##
	
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
		GlobalSignals.emit_signal("request_new_flee_point", self)
	##
##

func get_consumption_addition():
	return ConsumptionAddition
##

func begin_conversion_by(cultist):
	being_converted = true
	cultist_converting = cultist
	destination_wait_timer.start(ConversionSpeed)
##

func being_converted_by() -> Cultist:
	return cultist_converting
##

func rolled_over():
	# spawn particle
	
	# spawn sound effect at location
	
	# die
	queue_free()
##
