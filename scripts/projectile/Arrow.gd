extends CharacterBody2D

## Countdown until the munition expires.
@export var countdown:float = 3

@onready var trail = $Trail

func _ready():
	trail.emitting = true
##

func _process(delta):
	if countdown <= 0:
		queue_free()
	else:
		countdown -= delta
	##
##

func _physics_process(delta):
	move_and_slide()
##

func _on_damage_area_body_entered(body):
	if body is Cultist or body is FleshBall2D or body is Lich:
		body.take_damage(3)
	##
	$AudioStreamPlayer2D.pitch_scale = randf_range(0.5, 1.5)
	$AudioStreamPlayer2D.play()
	$Timer.start()
##


func _on_timer_timeout():
	queue_free()
##
