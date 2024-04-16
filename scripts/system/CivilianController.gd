extends Node2D

@export var FleePoints:Node2D
@export var ExitPoints:Node2D

func _ready():
	GlobalSignals.connect("request_new_flee_point", _new_flee_point_requested)
	GlobalSignals.connect("request_escort_point", _request_escort_point)
##

func _new_flee_point_requested(civy):
	var rand_point = FleePoints.get_child(randi() % FleePoints.get_child_count())
	civy.set_target_position(rand_point.global_position)
##

func _request_escort_point(civy:Civilian, adventurer:Adventurer):
	var bp_dist:float = civy.global_position.distance_squared_to(ExitPoints.get_child(0).global_position)
	var bp_indx:int = 0
	for pindx in range(1, ExitPoints.get_child_count()):
		var dist = civy.global_position.distance_squared_to(ExitPoints.get_child(pindx).global_position)
		if dist < bp_dist:
			bp_dist = dist
			bp_indx = pindx
		##
	##
	
	civy.set_target_position(ExitPoints.get_child(bp_indx).global_position)
	adventurer.target = ExitPoints.get_child(bp_indx)
##
