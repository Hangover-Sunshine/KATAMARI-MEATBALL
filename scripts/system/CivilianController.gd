extends Node2D

@export var FleePoints:Node2D
@export var ExitPoints:Node2D
@export var CivilianPrefab:PackedScene

@onready var spawn_points = $SpawnPoints

const FX_EXPLODE_BLOOD = preload("res://prefabs/particles/fx_explode_blood.tscn")

func _ready():
	GlobalSignals.connect("request_new_flee_point", _new_flee_point_requested)
##

func make_new_civilian(start_pos):
	var spawn_pos:Vector2 = spawn_points.get_child(randi() % spawn_points.get_child_count()).global_position
	var loaded:Civilian = CivilianPrefab.instantiate()
	add_child(loaded)
	loaded.global_position = spawn_pos + Vector2(randf_range(-20, 20), randf_range(-20, 20))
##

func _new_flee_point_requested(civy):
	var rand_point = FleePoints.get_child(randi() % FleePoints.get_child_count())
	civy.set_target_position(rand_point.global_position)
##

func dead(pos):
	var blood = FX_EXPLODE_BLOOD.instantiate()
	add_child(blood)
	blood.global_position = pos
	blood.play()
##
