extends CharacterBody2D
class_name FleshBall2D

@export var StartingSize:float = 50
@export_group("Velocity Affectors")
## When hit, how much velocity to add
@export var MaxVelocity:float = 1000
## How much velocity is retained when the ball hits the wall.
@export_range(0.0, 1.0) var BounceVelocityRetain:float = 0.8
## Loss of movement overtime, without hitting a wall.
@export_range(0.01, 0.6) var MovementLoss:float = 0.2
## How fast the ball loses momentum. Time is in seconds.
@export var MovementLossTime:float = 2.5
## Impact of damage on velocity. Default was 10 for the jam, but proved too punishing.
@export var VelImpactMultiplier:float = 10

@onready var no_break_pool = $NoBreakPool
@onready var influence:Area2D = $Influence
@onready var ball3d = $"BallView/Ball3D"
@onready var actual_hitbox:CollisionShape2D = $ActualHitbox
@onready var break_pool = $BreakPool
@onready var plant_break = $PlantBreak

var influence_cs:CollisionShape2D

var current_consumption:float
var off:bool = true
var flash_playing:bool = false

var momentum_loss_timer:float = 0

func _ready():
	$Influence.collision_mask = 0b0001_0000
	ball3d.max_speed = MaxVelocity
	current_consumption = StartingSize
	ball3d.set_ball_scale(current_consumption, false)
	
	influence_cs = influence.get_child(0)
	
	actual_hitbox.shape.radius = 74.3 * ball3d.model.mesh.radius + 40.4
	influence_cs.shape.radius = 74.3 * ball3d.model.mesh.radius + 40.4 + 70
##

func _process(delta):
	$BallDisplay.texture = $BallView.get_texture()
	ball3d.velocity = velocity
##

func _physics_process(delta):
	if is_zero_approx(velocity.length_squared()):
		if off:
			return
		else:
			# turn off influence -- only cultists can be absorbed
			$Influence.collision_mask = 0b0001_0000
			off = true
			momentum_loss_timer = 0
			return
		##
	elif off:
		off = false
		momentum_loss_timer = MovementLossTime
	##
	
	# otherwise, keep processing as normal
	# move and report collisions
	var collision:KinematicCollision2D = move_and_collide(velocity * delta)
	
	# for next frame, reflect and apply new velocity for next time
	if collision:
		var obj = collision.get_collider()
		if obj.can_be_destroyed(velocity.length(), current_consumption):
			if obj is Destruct_Cottage or obj is Destruct_Wood:
				break_pool.play_random_sound()
			elif obj is Destruct_Tree or obj is Destruct_Plant:
				plant_break.play_random_sound()
			else:
				pass
			##
			obj.destroy()
			velocity *= (1 - obj.VelocityReduction)
		else:
			no_break_pool.play_random_sound()
			obj.hit()
			velocity = velocity.bounce(collision.get_normal()) * BounceVelocityRetain
		##
	##
	
	momentum_loss_timer -= delta
	if momentum_loss_timer <= 0:
		momentum_loss_timer = MovementLossTime
		
		velocity -= velocity * MovementLoss
		
		if velocity.length_squared() < 3500: # player can no longer be sucked in
			$Influence.collision_mask = 0b0001_1100
		##
	##
##

func smacked(dir, force):
	# add to it, don't override
	velocity += (MaxVelocity * force) * dir
	$Influence.collision_mask = 0b0001_1100
##

func take_damage(damage):
	if velocity.length_squared() > 2000:
		var vel_impact = damage * VelImpactMultiplier
		
		if velocity.x > 0:
			velocity.x -= vel_impact
		elif velocity.x < 0:
			velocity.x += vel_impact
		##
		
		if velocity.y > 0:
			velocity.y -= vel_impact
		elif velocity.y < 0:
			velocity.y += vel_impact
		##
		
		return
	##
	
	flash()
	current_consumption -= damage
	ball3d.set_ball_scale(current_consumption, true)
	LWSave.Prefs["game"]["ball_real"] = current_consumption
	
	# ball's gone, oops
	if current_consumption <= 0:
		GlobalSignals.emit_signal("ball_destroyed")
		queue_free()
	##
##

# once in, you can never leave :)
func _on_influence_body_entered(body):
	current_consumption += body.get_consumption_addition()
	
	if current_consumption >= LWSave.Prefs["game"]["ball"]:
		LWSave.Prefs["game"]["ball"] = current_consumption
	##
	
	ball3d.set_ball_scale(current_consumption, false)
	LWSave.Prefs["game"]["ball_real"] = current_consumption
	
	actual_hitbox.shape.radius = 74.3 * ball3d.model.mesh.radius + 40.4
	influence_cs.shape.radius = 74.3 * ball3d.model.mesh.radius + 40.4 + 70
	
	if velocity.length_squared() > 0:
		body.rolled_over()
	else:
		body.get_absorbed()
	##
##

func flash():
	if flash_playing:
		return
	flash_playing = true
	$FlashTimer.start()
	$BallDisplay.material.set_shader_parameter("hit_opacity", 0.5)
##

func _on_flash_timer_timeout():
	flash_playing = false
	$BallDisplay.material.set_shader_parameter("hit_opacity", 0)
##
