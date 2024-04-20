extends Node2D

@onready var send_timer = $SendTimer
@onready var attack_player_animation = $AttackPlayer_Animation

var attack_playing:bool = false
var exploded:bool = false
var dir:Vector2

func _ready():
	$"Mage Limb/Limb".frame = randi_range(0, 1)
##

func _process(_delta):
	if attack_playing and attack_player_animation.is_playing() == false:
		send_timer.start(0.1)
		attack_playing = false
	##
	
	global_position += dir * 5
##

func play_growth():
	attack_player_animation.play("Attack")
	attack_playing = true
##

func _on_send_timer_timeout():
	if exploded:
		queue_free()
	else:
		attack_player_animation.play("Explode")
		exploded = true
		$SendTimer.start(1)
	##
##
