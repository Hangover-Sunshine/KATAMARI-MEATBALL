extends Adventurer
class_name MeleeHero

@export var MeleeHealth:Vector2 = Vector2(5, 8)

@onready var melee = $Melee
@onready var travel_brain = $TravelBrain
@onready var attack_anim = $AttackAnim
@onready var sound_pool_2d = $SoundPool2D

func _ready():
	venture_type = 2
	health = randi_range(MeleeHealth.x, MeleeHealth.y)
	super()
##

func _process(delta):
	if attack:
		# rotate around self
		var angle = rad_to_deg(global_position.angle_to_point(target.global_position)) + 180
		
		if angle > 225 and angle <= 310:
			$Melee.rotation = deg_to_rad(90)
		elif angle > 125 and angle <= 225:
			$Melee.rotation = deg_to_rad(0)
		elif angle >= 45 and angle <= 125:
			$Melee.rotation = deg_to_rad(270)
		else:
			$Melee.rotation = deg_to_rad(180)
		##
		
		if attack_anim.is_playing() == false:
			sound_pool_2d.play_random_sound()
			attack_anim.play("melee_attack")
		##
	##
##

func _physics_process(delta):
	if attack:
		$GraphicsController.play_idle()
		return
	##
	
	if travel_brain.is_navigation_finished():
		$GraphicsController.play_idle()
		travel_brain.target_position = target.global_position
	##
	
	$GraphicsController.play_waddle()
	velocity = global_position.direction_to(travel_brain.get_next_path_position()) * MovementSpeed
	move_and_slide()
##

func _on_entity_in_range_body_entered(body):
	attack = true
	velocity = Vector2.ZERO
##

func _on_entity_in_range_body_exited(body):
	attack = false
##

# Only melee use this function!
func _on_hit_area_body_entered(body):
	body.take_damage(2)
##
