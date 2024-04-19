extends Node2D

@export var MeleeHeroPrefab:PackedScene
@export var RangedHeroPrefab:PackedScene
@export var Fleshball:FleshBall2D
@export var Player:Lich
@export var ProjectileHolder:Node2D

func spawn_hero(start_position, is_melee:bool):
	var loaded:Adventurer
	if is_melee:
		loaded = MeleeHeroPrefab.instantiate()
		add_child(loaded)
		loaded.target = Player
	else:
		loaded = RangedHeroPrefab.instantiate()
		add_child(loaded)
		loaded.target = Fleshball if Fleshball != null else Player
		loaded.ball = Fleshball
		loaded.projectile_spawner = ProjectileHolder
	##
	loaded.global_position = start_position
	loaded.player = Player
##
