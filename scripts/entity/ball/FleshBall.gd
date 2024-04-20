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

@onready var influence:Area2D = $Influence
@onready var ball3d = $"BallView/Ball3D"
@onready var actual_hitbox:CollisionShape2D = $ActualHitbox
var influence_cs:CollisionShape2D

var current_consumption:float
var off:bool = true

var momentum_loss_timer:float = 0

func _ready():
	$Influence.collision_mask = 0b0001_0000
	ball3d.max_speed = MaxVelocity
	current_consumption = StartingSize
	ball3d.set_ball_scale(current_consumption)
	
	influence_cs = influence.get_child(0)
	
	print(ball3d.model.mesh.radius)
	
	actual_hitbox.shape.radius = 50
	influence_cs.shape.radius = 70 + current_consumption
##
var i = 0
func _input(event):
	if event.is_action_pressed("ui_up"):
		current_consumption += 10
		ball3d.set_ball_scale(current_consumption)
		print("BALL3D RAD: ", ball3d.model.mesh.radius)
		actual_hitbox.shape.radius = 74.3 * ball3d.model.mesh.radius + 40.4
	##
	if event.is_action_pressed("ui_down"):
		current_consumption -= 10
		ball3d.set_ball_scale(current_consumption)
		print("BALL3D RAD: ", ball3d.model.mesh.radius)
		actual_hitbox.shape.radius = 74.3 * ball3d.model.mesh.radius + 40.4
	##
	
	if event.is_action_pressed("WalkUp"):
		actual_hitbox.shape.radius += 2
		print("HITBOX RAD: ", actual_hitbox.shape.radius)
	##
	if event.is_action_pressed("WalkDown"):
		actual_hitbox.shape.radius -= 2
		print("HITBOX RAD: ", actual_hitbox.shape.radius)
	##
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
			obj.destroy()
			velocity *= (1 - obj.VelocityReduction)
		else:
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
		var vel_impact = damage * 10
		
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
	
	current_consumption -= damage
	ball3d.set_ball_scale(current_consumption)
	
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
	
	ball3d.set_ball_scale(current_consumption)
	
	actual_hitbox.scale = Vector2(current_consumption * ball3d.get_ball_scale(), current_consumption * ball3d.get_ball_scale())
	#actual_hitbox.scale = Vector2(ball3d.get_ball_scale(), ball3d.get_ball_scale())
	#actual_hitbox.shape.radius = current_consumption / 1.6
	#influence_cs.shape.radius = 70 + current_consumption
	
	if velocity.length_squared() > 0:
		body.rolled_over()
	else:
		body.get_absorbed()
	##
##
