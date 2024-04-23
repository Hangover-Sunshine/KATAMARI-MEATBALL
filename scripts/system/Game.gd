extends Node2D

## Maximum number of spawnable entities.
@export var MaxEntities:int = 200
## How much to offset the time up by.
@export var SpawnTimeOffset:Vector2 = Vector2(0.5, 1.5)
## Range of the number of entities to spawn when the timer goes off.
@export var SpawnEntityRange:Vector2i = Vector2i(4, 10)

@export_group("References")
## Reference to the player
@export var Player:Lich
## Reference to the camera
@export var Camera:Camera2D

@onready var spawn_timer = $Details/SpawnTimer
@onready var cultist_controller = $CultistController
@onready var hero_controller = $HeroController
@onready var civilian_controller = $CivilianController
@onready var death_sounds_pool = $DeathSoundsPool
@onready var squish_pool = $SquishPool
@onready var rebake_timer = $Details/RebakeTimer

var player_dead:bool = false
var quitting:bool = false

var curr_num_of_entities:int = 0

var out_of_lvl0:bool = false
var made_it_to_3:bool = false
var allow_rangers:bool = false
var entity_displacement = [0.4, 0.5, 0.8]

func _ready():
	GlobalSignals.connect("player_out_of_health", _player_out_of_health)
	GlobalSignals.connect("entity_removed", _entity_removed)
	spawn_timer.start(2 + randf_range(SpawnTimeOffset.x, SpawnTimeOffset.y))
	Player.projectile_area = $ProjectileHolder
	GlobalSignals.connect("load_scene", _load_scene)
	rebake_timer.start(15)
##

func _load_scene(level):
	if level == "Menus/Hub_Menu":
		quitting = true
	##
##

func _entity_removed(death_pos, by_ball):
	if by_ball:
		squish_pool.play_random_sound_at(death_pos)
	else:
		death_sounds_pool.play_random_sound_at(death_pos)
	##
	curr_num_of_entities -= 1
##

func _on_spawn_timer_timeout():
	if curr_num_of_entities >= MaxEntities:
		spawn_timer.start(2 + randf_range(SpawnTimeOffset.x, SpawnTimeOffset.y))
		return
	##
	
	var num_entities:int = randi_range(SpawnEntityRange.x, SpawnEntityRange.y)
	curr_num_of_entities += num_entities
	
	var cultists = int(num_entities * entity_displacement[0])
	var civilians = int(num_entities * entity_displacement[1])
	var heroes = num_entities - cultists - civilians
	
	for i in range(cultists):
		cultist_controller.make_cultist(Vector2.ZERO)
	##
	
	for i in range(civilians):
		civilian_controller.make_new_civilian(Vector2.ZERO)
	##
	
	for i in range(heroes):
		var val = randf_range(0, 1)
		hero_controller.spawn_hero(Vector2.ZERO, val < entity_displacement[2])
	##
	
	if LWSave.Prefs["game"]["time"] > 70:
		entity_displacement = [0.2, 0.3, 0.6]
	elif LWSave.Prefs["game"]["time"] > 45:
		entity_displacement = [0.4, 0.3, 0.7]
	elif LWSave.Prefs["game"]["time"] > 30:
		entity_displacement = [0.4, 0.5, 0.8]
	##
	
	spawn_timer.start(randi_range(2, 4) + randf_range(SpawnTimeOffset.x, SpawnTimeOffset.y))
##

func _player_out_of_health():
	player_dead = true
	$PlayerDeathcry.global_position = Player.global_position
	$PlayerDeathcry.play()
	LWSave.Prefs["game"]["winner"] = false
	GlobalSignals.emit_signal("load_scene", "Menus/Game_Over")
##

func _on_play_area_body_exited(body):
	if player_dead or quitting:
		return
	##
	$CultistController.process_mode = Node.PROCESS_MODE_DISABLED
	$ProjectileHolder.process_mode = Node.PROCESS_MODE_DISABLED
	$CivilianController.process_mode = Node.PROCESS_MODE_DISABLED
	$HeroController.process_mode = Node.PROCESS_MODE_DISABLED
	LWSave.Prefs["game"]["winner"] = true
	GlobalSignals.emit_signal("load_scene", "Menus/Game_Over")
##

func _on_rebake_timer_timeout():
	$Map.bake_navigation_polygon()
	rebake_timer.start(10)
##
