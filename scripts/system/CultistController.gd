extends Node2D

@export var FleshBall:CharacterBody2D
@export var CultistPrefab:PackedScene

@onready var spawn_points = $SpawnPoints

const EXPLODE_WHITEPUFF = preload("res://prefabs/particles/fx_explode_whitepuff.tscn")
const FX_EXPLODE_BLOOD = preload("res://prefabs/particles/fx_explode_blood.tscn")

func _ready():
	GlobalSignals.connect("convert_citizen_to_cultist", _convert_citizen_to_cultist)
##

func make_cultist(start_pos):
	var spawn_pos:Vector2 = spawn_points.get_child(randi() % spawn_points.get_child_count()).global_position
	var loaded:Cultist = CultistPrefab.instantiate()
	add_child(loaded)
	loaded.fleshball = FleshBall
	loaded.global_position = spawn_pos + Vector2(randf_range(-20, 20), randf_range(-20, 20))
##

func _convert_citizen_to_cultist(civy:Civilian):
	var puff = EXPLODE_WHITEPUFF.instantiate()
	var loaded:Cultist = CultistPrefab.instantiate()
	add_child(loaded)
	add_child(puff)
	puff.global_position = civy.global_position
	puff.play()
	loaded.load_from_civvy(civy)
	loaded.fleshball = FleshBall
	loaded.global_position = civy.global_position
	civy.queue_free()
##

func dead(pos):
	var blood = FX_EXPLODE_BLOOD.instantiate()
	add_child(blood)
	blood.global_position = pos
	blood.play()
##
