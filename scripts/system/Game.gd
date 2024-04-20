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

var curr_num_of_entities:int = 0

var out_of_lvl0:bool = false
var made_it_to_3:bool = false
var allow_rangers:bool = false
var entity_displacement = [0.4, 0.5, 1]

func _ready():
	GlobalSignals.connect("player_out_of_health", _player_out_of_health)
	GlobalSignals.connect("ball_level_changed", _ball_level_changed)
	GlobalSignals.connect("ball_escaped", _ball_escaped)
	GlobalSignals.connect("entity_removed", _entity_removed)
	spawn_timer.start(2 + randf_range(SpawnTimeOffset.x, SpawnTimeOffset.y))
##

func _entity_removed():
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
	
	var scrn_sze = Camera.get_viewport_rect().size * Camera.zoom
	
	# never more than two will be impossible to spawn
	# l, t, r, b of cam
	var valid_spawn_locations = [0, 1, 2, 3]
	
	# either bound or none
	if Camera.global_position.x - scrn_sze.x > Camera.limit_left * 0.85:
		valid_spawn_locations.append(1)
	##
	if Camera.global_position.x + scrn_sze.x < Camera.limit_right * 0.85:
		valid_spawn_locations.append(2)
	##
	
	# either bound or none
	if Camera.global_position.y - scrn_sze.y > Camera.limit_top * 0.85:
		valid_spawn_locations.append(1)
	elif Camera.global_position.y + scrn_sze.y < Camera.limit_bottom * 0.85:
		valid_spawn_locations.append(3)
	##
	
	for i in range(cultists):
		var scrn_spawn = valid_spawn_locations[randi_range(0, len(valid_spawn_locations) - 1)]
		var spawn_pos:Vector2
		
		if scrn_spawn == 0:
			spawn_pos = Camera.global_position + Vector2(-scrn_sze.x - randf_range(-50, 0), randf_range(0, scrn_sze.y))
		elif scrn_spawn == 1:
			spawn_pos = Camera.global_position + Vector2(randf_range(0, scrn_sze.x), -scrn_sze.y - randf_range(-50, 0))
		elif scrn_spawn == 2:
			spawn_pos = Camera.global_position + Vector2(scrn_sze.x + randf_range(0, 50), randf_range(0, scrn_sze.y))
		else:
			spawn_pos = Camera.global_position + Vector2(randf_range(0, scrn_sze.x), scrn_sze.y + randf_range(0, 60))
		##
		
		cultist_controller.make_cultist(spawn_pos)
	##
	
	for i in range(civilians):
		var scrn_spawn = valid_spawn_locations[randi_range(0, len(valid_spawn_locations) - 1)]
		var spawn_pos:Vector2
		
		if scrn_spawn == 0:
			spawn_pos = Camera.global_position + Vector2(-scrn_sze.x - randf_range(-50, 0), randf_range(0, scrn_sze.y))
		elif scrn_spawn == 1:
			spawn_pos = Camera.global_position + Vector2(randf_range(0, scrn_sze.x), -scrn_sze.y - randf_range(-50, 0))
		elif scrn_spawn == 2:
			spawn_pos = Camera.global_position + Vector2(scrn_sze.x + randf_range(0, 50), randf_range(0, scrn_sze.y))
		else:
			spawn_pos = Camera.global_position + Vector2(randf_range(0, scrn_sze.x), scrn_sze.y + randf_range(0, 60))
		##
		
		civilian_controller.make_new_civilian(spawn_pos)
	##
	
	for i in range(heroes):
		var scrn_spawn = valid_spawn_locations[randi_range(0, len(valid_spawn_locations) - 1)]
		var spawn_pos:Vector2
		
		if scrn_spawn == 0:
			spawn_pos = Camera.global_position + Vector2(-scrn_sze.x - randf_range(-50, 0), randf_range(0, scrn_sze.y))
		elif scrn_spawn == 1:
			spawn_pos = Camera.global_position + Vector2(randf_range(0, scrn_sze.x), -scrn_sze.y - randf_range(-50, 0))
		elif scrn_spawn == 2:
			spawn_pos = Camera.global_position + Vector2(scrn_sze.x + randf_range(0, 50), randf_range(0, scrn_sze.y))
		else:
			spawn_pos = Camera.global_position + Vector2(randf_range(0, scrn_sze.x), scrn_sze.y + randf_range(0, 60))
		##
		
		var val = randf_range(0, 1)
		hero_controller.spawn_hero(spawn_pos, val < entity_displacement[2])
	##
	
	spawn_timer.start(randi_range(2, 4) + randf_range(SpawnTimeOffset.x, SpawnTimeOffset.y))
##

func _player_out_of_health():
	$PlayerDeathcry.global_position = Player.global_position
	$PlayerDeathcry.play()
	LWSave.Prefs["winner"] = false
	GlobalSignals.emit_signal("load_scene", "Menus/Game_Over")
##

func _ball_level_changed(lvl:int):
	if made_it_to_3:
		if lvl == 0:
			entity_displacement = [0.3, 0.5, 0.1]
		elif lvl == 1:
			entity_displacement = [0.3, 0.3, 0.7]
		else:
			entity_displacement = [0.3, 0.1, 0.4]
		##
	else:
		if lvl == 0:
			entity_displacement = [0.3, 0.5, 1]
		elif lvl == 1:
			entity_displacement = [0.3, 0.4, 0.9]
		else:
			made_it_to_3 = true
			entity_displacement = [0.2, 0.3, 0.5]
		##
	##
##

func _ball_escaped():
	LWSave.Prefs["winner"] = true
	GlobalSignals.emit_signal("load_scene", "Menus/Game_Over")
##
