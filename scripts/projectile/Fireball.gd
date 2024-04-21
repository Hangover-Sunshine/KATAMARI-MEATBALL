extends CharacterBody2D

@export var ExplodeTimer:float = 3

@onready var damage_zone = $DamageZone
@onready var timer = $Timer
@onready var sprite = $Sparkle
@onready var trail = $Trail
@onready var sparkle_player = $SparklePlayer
@onready var explode_timer = $ExplodeTimer

const FX_TRAIL_HEROPROJECTILE = preload("res://prefabs/particles/fx_trail_heroprojectile.tscn")

func _ready():
	explode_timer.start(ExplodeTimer)
	trail.emitting = true
	sparkle_player.play("Twirl")
##

func _process(_delta):
	if Input.is_action_just_pressed("ui_up"):
		_on_hit_detector_body_entered(null)
	##
##

func _physics_process(_delta):
	move_and_slide()
##

func _on_hit_detector_body_entered(body):
	velocity = Vector2.ZERO
	trail.emitting = false
	damage_zone.process_mode = Node.PROCESS_MODE_INHERIT
	timer.start()
	sprite.visible = false
	var expl = FX_TRAIL_HEROPROJECTILE.instantiate()
	get_parent().add_child(expl)
	expl.global_position = global_position
	expl.emitting = true
##

func _on_damage_zone_body_entered(body):
	if body is Entity or body is FleshBall2D or body is Lich:
		body.take_damage(4)
	##
##

func _on_timer_timeout():
	queue_free()
##

func _on_explode_timer_timeout():
	_on_hit_detector_body_entered(null)
##
