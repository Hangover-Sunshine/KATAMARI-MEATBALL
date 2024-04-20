extends Entity
class_name Adventurer

@export var MovementSpeed:float = 300.0

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
	LWSave.Prefs["game"]["hero_roll"] += 1
	GlobalSignals.emit_signal("entity_removed")
	queue_free()
##

func free_from_help():
	helping_civilian = false
	civilian = null
	target = player
##

func take_damage(dmg):
	if helping_civilian and civilian != null:
		civilian.escort_under_attack = true
	##
	health -= dmg
	if health <= 0:
		LWSave.Prefs["game"]["hero_punch"] += 1
		# do things
		GlobalSignals.emit_signal("entity_removed")
		queue_free()
	##
##
