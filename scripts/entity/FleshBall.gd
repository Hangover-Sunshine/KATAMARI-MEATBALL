extends RigidBody2D

@export var ConsumptionBands:Array[int]

@onready var influence = $Influence

var current_consumption:int = 0
var off:bool = true

func _ready():
	$Influence.collision_mask = 0
##

func _process(delta):
	pass
##

func _physics_process(delta):
	if is_zero_approx(linear_velocity.length_squared()):
		if off:
			return
		else:
			# turn off influence
			$Influence.collision_mask = 0
			off = true
		##
	elif off:
		# restart everything!
		$Influence.collision_mask = 0b0000_1101
		off = false
	##
	
	# otherwise, keep processing as normal
##

# once in, you can never leave :)
func _on_influence_body_entered(body):
	print(body)
##
