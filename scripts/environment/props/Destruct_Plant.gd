extends StaticBody2D
class_name Destruct_Plant

@onready var animation_player = $AnimationPlayer
@onready var plant = $Plant

@export var MinScoreThreshold:float = 500
@export var MinVelocityThreshold:float = 3500
@export_range(0.01, 1) var VelocityReduction:float = 0.6

func _ready():
	if plant.vframes > 1:
		randomize_sprite()
	blow_plant()

func destroy():
	# can't interact with the world
	collision_layer = 0
	collision_mask = 0
	# play the destruction particle
	# hide the actual sprite
	animation_player.play("Destroy")
	# process_mode = Node.PROCESS_MODE_DISABLED
	# show the destroyed ruins
##

func hit():
	pass

func can_be_destroyed(velSize, score):
	return velSize >= MinVelocityThreshold and score >= MinScoreThreshold
##

func randomize_sprite():
	plant.frame = randf_range(0, (plant.hframes * plant.vframes) + 1)
##

func blow_plant():
	animation_player.play("Wind")
	var offset : float = randf_range(0, animation_player.current_animation_length)
	animation_player.advance(offset)
