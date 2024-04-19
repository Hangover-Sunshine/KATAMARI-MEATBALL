extends Entity
class_name Adventurer

@export var MovementSpeed:float = 300.0
@export_range(0.1, 0.8) var EscortSpeedPenality:float = 0.5
#@export var RangedHealth:Vector2 = Vector2(2, 4)

#@onready var ranged = $Ranged

# Player or Fleshball or Civvy Exit
var target
var player:Lich

# 2 = Guard, 3 = Archer, 4 = Wizard
var venture_type:int

var attack:bool = false
var helping_civilian:bool = false

var help_after:Civilian
var civilian:Civilian

func _ready():
	$GraphicsController.character = venture_type
	$GraphicsController.generate_character()
##

func rolled_over():
	GlobalSignals.emit_signal("entity_removed")
	queue_free()
##

func free_from_help():
	helping_civilian = false
	civilian = null
	target = player
##

func take_damage(dmg):
	if helping_civilian:
		civilian.escort_under_attack = true
	##
	health -= dmg
	if health <= 0:
		# do things
		GlobalSignals.emit_signal("entity_removed")
		queue_free()
	##
##
