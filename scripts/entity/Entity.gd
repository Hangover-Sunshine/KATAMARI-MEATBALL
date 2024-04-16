extends CharacterBody2D
class_name Entity

@export var ConsumptionScore:float = 1.0

var health:int

func rolled_over():
	pass
##

func get_consumption_addition():
	return ConsumptionScore
##

func take_damage(dmg):
	health -= dmg
##
