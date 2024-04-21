extends Control

@onready var giu_label_score = $GIU_MarginContainer/GIU_VBoxContainer/GIU_Label_Score
@onready var giu_warning = $GIU_MarginContainer/GIU_VBoxContainer/GIU_Warning

func _process(delta):
	if LWSave.Prefs["game"]["ball_real"] < 600:
		giu_label_score.text = "%.2f" % [LWSave.Prefs["game"]["ball_real"]]
	else:
		pass
	##
##
