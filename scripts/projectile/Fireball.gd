extends CharacterBody2D

@onready var damage_zone = $DamageZone
@onready var timer = $Timer
@onready var sprite = $Sprite2D

func _physics_process(delta):
	move_and_slide()
##

func _on_hit_detector_body_entered(body):
	velocity = Vector2.ZERO
	damage_zone.process_mode = Node.PROCESS_MODE_INHERIT
	timer.start()
	sprite.visible = false
##

func _on_damage_zone_body_entered(body):
	if body is Entity or body is FleshBall2D:
		body.take_damage(4)
	##
##

func _on_timer_timeout():
	queue_free()
##
