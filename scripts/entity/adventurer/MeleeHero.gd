extends Adventurer
class_name MeleeHero

@export var MeleeHealth:Vector2 = Vector2(5, 8)

@onready var melee = $Melee
@onready var travel_brain = $TravelBrain
@onready var attack_anim = $AttackAnim

func _ready():
	venture_type = 2
	health = randi_range(MeleeHealth.x, MeleeHealth.y)
	super()
##

func _process(delta):
	if attack:
		# rotate around self
		var angle = rad_to_deg(global_position.angle_to_point(target.global_position)) + 180
		
		if angle >= 225 and angle <= 310:
			$Melee.rotation = deg_to_rad(90)
		elif angle >= 125 and angle < 225:
			$Melee.rotation = deg_to_rad(0)
		elif angle >= 60 and angle < 125:
			$Melee.rotation = deg_to_rad(270)
		else:
			$Melee.rotation = deg_to_rad(180)
		##
		
		if attack_anim.is_playing() == false:
			attack_anim.play("melee_attack")
		##
	##
##

func _physics_process(delta):
	if attack or\
		(helping_civilian and global_position.is_equal_approx(target.global_position)):
		return
	##
	
	if travel_brain.is_navigation_finished() and target != null:
		travel_brain.target_position = target.global_position
	##
	
	var speed:float = MovementSpeed if helping_civilian == false else MovementSpeed * EscortSpeedPenality 
	
	velocity = global_position.direction_to(travel_brain.get_next_path_position()) * speed
	move_and_slide()
##

func _on_entity_in_range_body_entered(body):
	if (body is Lich or body is Cultist) and target == body:
		attack = true
		velocity = Vector2.ZERO
	##
	
	if body is Civilian and target == body:
		target.start_escorting(self)
		civilian = body
		helping_civilian = true
	##
##

func _on_entity_in_range_body_exited(body):
	if (body is Lich or body is Cultist) and body == target:
		attack = false
		if help_after != null:
			help_after.start_escorting(self)
			civilian = help_after
			help_after = null
		##
	##
##

# Only melee use this function!
func _on_hit_area_body_entered(body):
	body.take_damage(2)
##

func _on_npc_sighter_body_entered(body):
	if helping_civilian == false:
		if body is Civilian and !(target is Civilian):
			var maybe_targ = body.being_converted_by()
			if maybe_targ:
				target = maybe_targ
				help_after = body
			else:
				target = body
			##
		##
	##
##
