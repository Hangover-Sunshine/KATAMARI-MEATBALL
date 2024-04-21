extends Control

@onready var giu_label_score = $GIU_MarginContainer/GIU_VBoxContainer/GIU_Label_Score
@onready var giu_warning1 = $GIU_MarginContainer/GIU_VBoxContainer/GIU_Warning
@onready var animation_player = $AnimationPlayer
@onready var giu_warning2 = $GIU_MarginContainer/GIU_VBoxContainer/GIU_Warning2

func _ready():
	giu_label_score.visible = true
	giu_warning1 = false
	giu_warning2 = false

func _process(delta):
	if LWSave.Prefs["game"]["ball_real"] < 600:
		animation_player.play("WinToScore")
		giu_label_score.text = "%.2f" % [LWSave.Prefs["game"]["ball_real"]]
	else:
		giu_label_score.visible = false
		animation_player.play("ScoreToWin")
		pass
	##
##
