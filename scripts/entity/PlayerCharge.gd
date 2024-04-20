extends Node2D

func _process(delta):
	global_position = get_global_mouse_position()
##

func scale_up(frac):
	$Charge.emitting = true
	$Charge.scale_amount_min = 0.3 * frac
	$Charge.scale_amount_max = 0.5 * frac
##

func dissipate():
	$ChargePlayer.play("Dissapate")
##
