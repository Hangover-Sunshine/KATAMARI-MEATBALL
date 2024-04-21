extends CharacterBody2D
class_name Lich

@export var MaxHealth:int = 50
@export var Speed:float = 300.0
@export_range(0.0, 1.0) var PunchDrawnPenalty:float = 0.8

@export var MaxWindupTime:float = 2.5
@export var Damage:int = 5

@onready var punch_meat_pool = $PunchMeatPool
@onready var punch_wiff = $PunchWiff
@onready var punch_people_pool = $PunchPeoplePool
@onready var health_bar = $HealthBar
@onready var hb_timer = $HBTimer
@onready var player_charge = $PlayerCharge
@onready var player_hit = $PlayerHit

const PLAYER_ATTACK = preload("res://prefabs/projectiles/player_attack.tscn")

var time_since_held:float = 0
var mouse_pressed:bool = false
var ball:CharacterBody2D
var health
var enemies_in_way:Array = []

var just_unpaused:bool = false

var projectile_area

func _ready():
	health = MaxHealth
	$GraphicsController.character = 0
	health_bar.value = MaxHealth
	health_bar.max_value = MaxHealth
	health_bar.visible = false
##

func punch(dir_from_player_to_mouse):
	var att = PLAYER_ATTACK.instantiate()
	projectile_area.add_child(att)
	att.global_position = global_position
	att.dir = dir_from_player_to_mouse
	att.look_at(get_global_mouse_position())
	# play growth
	att.play_growth()
	
	if ball == null and len(enemies_in_way) == 0:
		punch_wiff.play_random_sound()
		return
	##
	
	if ball != null:
		ball.smacked(dir_from_player_to_mouse, clampf(time_since_held / MaxWindupTime, 0, 1))
		punch_meat_pool.play_random_sound()
	##
	
	if len(enemies_in_way) > 0 and ball == null:
		punch_people_pool.play_random_sound()
	##
	
	for e in enemies_in_way:
		e.take_damage(Damage)
		if health < MaxHealth:
			health += Damage
			if health > MaxHealth:
				health = MaxHealth
			##
		##
	##
	
	if len(enemies_in_way) > 0:
		hb_timer.start(1.5)
	##
	
	health_bar.value = health
##

func _process(delta):
	if just_unpaused == true:
		just_unpaused = false
		return
	##
	
	if Input.is_action_just_pressed("Punch"):
		mouse_pressed = true
		time_since_held = 0
	elif Input.is_action_just_released("Punch"):
		mouse_pressed = false
		player_charge.dissipate()
		punch(global_position.direction_to(get_global_mouse_position()).normalized())
	##
	
	if mouse_pressed:
		time_since_held += delta
		player_charge.scale_up(clampf(time_since_held / MaxWindupTime, 0, 1))
	##
##

func _physics_process(delta):
	$Rotator.look_at(get_global_mouse_position())
	
	var x_dir = Input.get_axis("WalkLeft", "WalkRight")
	var y_dir = Input.get_axis("WalkUp", "WalkDown")
	
	if x_dir:
		velocity.x = x_dir * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
	##
	
	if y_dir:
		velocity.y = y_dir * Speed
	else:
		velocity.y = move_toward(velocity.y, 0, Speed)
	##
	
	if (x_dir or y_dir):
		$GraphicsController.play_waddle()
		#step_pool.play_random_sound()
	else:
		$GraphicsController.play_idle()
	##
	
	move_and_slide()
##

func _on_entity_punch_detector_body_entered(body):
	if body is FleshBall2D:
		ball = body
	else:
		enemies_in_way.append(body)
	##
##

func _on_entity_punch_detector_body_exited(body):
	if body is FleshBall2D:
		ball = null
	else:
		enemies_in_way.remove_at(enemies_in_way.find(body))
	##
##

func take_damage(dmg):
	health -= dmg
	health_bar.visible = true
	health_bar.value -= dmg
	hb_timer.start(3)
	player_hit.play_random_sound()
	if health <= 0:
		# spawn death particles
		GlobalSignals.emit_signal("player_out_of_health")
		process_mode = Node.PROCESS_MODE_DISABLED
	##
	$GraphicsController.flash()
##

func _on_hb_timer_timeout():
	health_bar.visible = false
##
