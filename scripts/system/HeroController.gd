extends Node2D

@export var MeleeHeroPrefab:PackedScene
@export var RangedHeroPrefab:PackedScene
@export var Fleshball:FleshBall2D
@export var Player:Lich
@export var ProjectileHolder:Node2D

@onready var spawn_points = $SpawnPoints

const FX_EXPLODE_BLOOD = preload("res://prefabs/particles/fx_explode_blood.tscn")

func spawn_hero(start_position, is_melee:bool):
	var spawn_pos:Vector2 = spawn_points.get_child(randi() % spawn_points.get_child_count()).global_position
	var loaded:Adventurer
	if is_melee:
		loaded = MeleeHeroPrefab.duplicate(true).instantiate()
		add_child(loaded)
		loaded.target = Player
	else:
		loaded = RangedHeroPrefab.duplicate(true).instantiate()
		add_child(loaded)
		loaded.target = Fleshball if Fleshball != null else Player
		loaded.ball = Fleshball
		loaded.projectile_spawner = ProjectileHolder
	##
	loaded.global_position = spawn_pos + Vector2(randf_range(-20, 20), randf_range(-20, 20))
	loaded.player = Player
##

func dead(pos):
	var blood = FX_EXPLODE_BLOOD.instantiate()
	add_child(blood)
	blood.global_position = pos
	blood.play()
##
