extends CPUParticles2D

var play_called:bool = false

func play():
	emitting = true
	play_called = true
##

func _process(delta):
	if emitting == false and play_called:
		queue_free()
	##
##
