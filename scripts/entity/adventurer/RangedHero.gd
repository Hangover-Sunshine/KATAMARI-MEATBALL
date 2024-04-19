extends Adventurer
class_name RangedHero

@export var RangedHealth:Vector2 = Vector2(4, 6)
@export var ProjectileSpawnTimer:float = 0.45
@export var MageProjectile:PackedScene
@export var RangerProjectile:PackedScene
@export var ProjectileSpeed:Vector2 = Vector2(1200, 2000)

##

@onready var travel_brain = $TravelBrain
@onready var spawn_projectile_timer = $SpawnProjectileTimer

@onready var ball:FleshBall2D

var ball_in_range:bool = false
var in_range_for_attack:bool = false

var projectile_spawner

# BEHAVIORS:
# default target is the flesh ball
# if ball is dead, target player

func _ready():
	venture_type = 4 #randi_range(3, 4)
	health = randi_range(RangedHealth.x, RangedHealth.y)
	super()
##

func _process(_delta):
	if target == null:
		if ball != null:
			target = ball
		else:
			target = player
		##
	##
##

func _physics_process(delta):
	if attack:
		return
	##
	
	# check if we can actually SEE the target
	if in_range_for_attack:
		var space_state = get_world_2d().direct_space_state
		# use global coordinates, not local to node
		var query = PhysicsRayQueryParameters2D.create(global_position, target.global_position,
														0b0010_0011, [self])
		var result = space_state.intersect_ray(query)
		
		if result:
			attack = true
			velocity = Vector2.ZERO
			spawn_projectile_timer.start(ProjectileSpawnTimer)
			return
		##
	##
	
	if travel_brain.is_navigation_finished() and target != null:
		travel_brain.target_position = target.global_position
	##
	
	velocity = global_position.direction_to(travel_brain.get_next_path_position()) * MovementSpeed
	move_and_slide()
##

func _on_sight_range_body_entered(body):
	if body == target and (target is FleshBall2D or target is Cultist or target is Lich):
		in_range_for_attack = true
		if target is FleshBall2D:
			ball_in_range = true
		##
	##
##

func _on_sight_range_body_exited(body):
	if body == target and (target is FleshBall2D or target is Cultist or target is Lich):
		in_range_for_attack = false
		if target is FleshBall2D:
			ball_in_range = false
		##
	##
##

func _on_spawn_projectile_timer_timeout():
	if in_range_for_attack == false:
		attack = false
	else:
		spawn_projectile_timer.start(ProjectileSpawnTimer)
	##
	
	var dir = global_position.direction_to(target.global_position)
	# spawn projectile, add to general tree -- if the ranger dies, don't destroy everything
	if venture_type == 3:
		var proj = RangerProjectile.instantiate()
		projectile_spawner.add_child(proj)
		proj.global_position = global_position
		proj.rotation = dir.angle()
		proj.velocity = dir * randf_range(ProjectileSpeed.x, ProjectileSpeed.y)
	else:
		var proj = MageProjectile.instantiate()
		projectile_spawner.add_child(proj)
		proj.global_position = global_position
		proj.rotation = dir.angle()
		proj.velocity = dir * (randf_range(ProjectileSpeed.x, ProjectileSpeed.y) + 200)
	##
##
