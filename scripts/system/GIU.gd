extends Control

@onready var giu_label_score = $GIU_MarginContainer/GIU_VBoxContainer/GIU_Label_Score
@onready var giu_warning = $GIU_MarginContainer/GIU_VBoxContainer/GIU_Warning

func _process(delta):
	if LWSave.Prefs["game"]["ball_real"] < 600:
		var ball_size = LWSave.Prefs["game"]["ball_real"]
		var meters:float = 0
		var leading_zeros:int = 3
		while ball_size > 100:
			meters += 1
			ball_size -= 100
		##
		
		var decimal = "%.2f" % ball_size
		var meter_string = "%*d" % [leading_zeros, meters]
		
		giu_label_score.text = meter_string + decimal
	else:
		pass
	##
##
