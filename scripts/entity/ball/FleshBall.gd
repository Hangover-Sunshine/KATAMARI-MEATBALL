extends CharacterBody2D
class_name FleshBall2D

## The bands for jumping between sizes.
@export var ConsumptionBands:Array[float]

@export_group("Velocity Affectors")
## When hit, how much velocity to add
@export var MaxVelocity:float = 1000
## How much velocity is retained when the ball hits the wall.
@export_range(0.0, 1.0) var BounceVelocityRetain:float = 0.8
## Loss of movement overtime, without hitting a wall.
@export_range(0.01, 0.6) var MovementLoss:float = 0.2
## How fast the ball loses momentum. Time is in seconds.
@export var MovementLossTime:float = 2.5

@onready var influence = $Influence
@onready var ball3d = $"BallView/Ball3D"

var current_consumption:float = 0
var off:bool = true

var momentum_loss_timer:float = 0

func _ready():
	$Influence.collision_mask = 0b0001_0000
	ball3d.max_speed = MaxVelocity
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
			# turn off influence -- only cultists can be absorbeds
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
		velocity = velocity.bounce(collision.get_normal()) * BounceVelocityRetain
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

# once in, you can never leave :)
func _on_influence_body_entered(body):
	current_consumption += body.get_consumption_addition()
	
	if velocity.length_squared() > 0:
		body.rolled_over()
	else:
		body.get_absorbed()
	##
##
