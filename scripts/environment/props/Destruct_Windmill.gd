extends StaticBody2D
class_name Destruct_Windmill

@onready var animation_player = $AnimationPlayer
@onready var object = $Building/Cottage/Object
@onready var fan = $FanPlayer


@export var MinScoreThreshold:float = 500
@export var MinVelocityThreshold:float = 3500
@export_range(0.01, 1) var VelocityReduction:float = 0.6

func _ready():
	randomize_sprite()
	blow()

func destroy():
	# can't interact with the world
	collision_layer = 0
	collision_mask = 0
	# play the destruction particle
	# hide the actual sprite
	fan.stop()
	animation_player.play("Destroy")
	# process_mode = Node.PROCESS_MODE_DISABLED
	# show the destroyed ruins
##

func hit():
	animation_player.play("Hit")
	pass

func can_be_destroyed(velSize, score):
	return velSize >= MinVelocityThreshold and score >= MinScoreThreshold
##

func blow():
	fan.play("Blow")
	var offset : float = randf_range(0, $FanPlayer.current_animation_length)
	fan.advance(offset)

func randomize_sprite():
	object.frame = randf_range(0, (object.hframes * object.vframes))
