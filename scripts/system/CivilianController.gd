extends Node2D

@export var FleePoints:Node2D

func _ready():
	GlobalSignals.connect("request_new_flee_point", _new_flee_point_requested)
##

func _new_flee_point_requested(civy):
	var rand_point = FleePoints.get_child(randi() % FleePoints.get_child_count())
	civy.set_target_position(rand_point.global_position)
##
