extends Node2D

@onready var rotate_limb_animation = $RotateLimb_Animation


# Called when the node enters the scene tree for the first time.
func _ready():
	rotate_limb_animation.play("Rotate")
	var offset : float = randf_range(0, rotate_limb_animation.current_animation_length)
	rotate_limb_animation.advance(offset)
