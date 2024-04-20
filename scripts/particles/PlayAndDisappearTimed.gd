extends CPUParticles2D

@export var delete:bool = true

@onready var timer = $Timer

func _ready():
	if delete:
		timer.start()
##

func _on_timer_timeout():
	if emitting:
		emitting = false
		timer.start(1)
	else:
		queue_free()
	##
##
