extends Node2D

@export var FleshBall:CharacterBody2D
@export var CultistPrefab:PackedScene

func _ready():
	GlobalSignals.connect("convert_citizen_to_cultist", _convert_citizen_to_cultist)
##

func make_cultist(start_pos):
	var loaded:Cultist = CultistPrefab.instantiate()
	add_child(loaded)
	loaded.fleshball = FleshBall
	loaded.global_position = start_pos
##

func _convert_citizen_to_cultist(civy:Civilian):
	var loaded:Cultist = CultistPrefab.instantiate()
	add_child(loaded)
	loaded.load_from_civvy(civy)
	loaded.fleshball = FleshBall
	loaded.global_position = civy.global_position
	civy.queue_free()
##
