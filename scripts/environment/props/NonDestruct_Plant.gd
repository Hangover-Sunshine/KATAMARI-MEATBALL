extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var plant = $Plant

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_sprite()
	blow_plant()

func randomize_sprite():
	plant.frame = randf_range(0, (plant.hframes * plant.vframes) + 1)
	
func blow_plant():
	animation_player.play("Wind")
	var offset : float = randf_range(0, animation_player.current_animation_length)
	animation_player.advance(offset)
