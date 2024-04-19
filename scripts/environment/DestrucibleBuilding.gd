extends StaticBody2D
class_name DestructibleBuilding

@export var MinScoreThreshold:float = 500
@export var MinVelocityThreshold:float = 3500
@export_range(0.01, 1) var VelocityReduction:float = 0.6

func destroy():
	# can't interact with the world
	collision_layer = 0
	collision_mask = 0
	# play the destruction particle
	# hide the actual sprite
	$Sprite2D.visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	# show the destroyed ruins
##

func can_be_destroyed(velSize, score):
	return velSize >= MinVelocityThreshold and score >= MinScoreThreshold
##
