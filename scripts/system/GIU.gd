extends Control

@onready var giu_label_score = $GIU_MarginContainer/GIU_VBoxContainer/GIU_Label_Score
@onready var giu_warning1 = $GIU_MarginContainer/GIU_VBoxContainer/GIU_Warning1
@onready var animation_player = $AnimationPlayer
@onready var giu_warning2 = $GIU_MarginContainer/GIU_VBoxContainer/GIU_Warning2
@onready var giu_start1 = $GIU_MarginContainer/GIU_VBoxContainer/GIU_Start1
@onready var giu_start2 = $GIU_MarginContainer/GIU_VBoxContainer/GIU_Start2
@onready var giu_gameover = $GIU_MarginContainer/GIU_VBoxContainer/GIU_GameOver


func _ready():
	giu_label_score.visible = false
	giu_warning1.visible = false
	giu_warning2.visible = false
	giu_start1.visible = true
	giu_start1.visible = false
	giu_gameover.visible = false

func _process(delta):
	if (LWSave.Prefs["game"]["ball_real"] < 600) && (LWSave.Prefs["game"]["ball_real"] > 75):
		animation_player.play("ToScore")
		giu_label_score.text = "%.2f" % [LWSave.Prefs["game"]["ball_real"]]
	elif (LWSave.Prefs["game"]["ball_real"] > 599):
		animation_player.play("ToWin")
	elif (LWSave.Prefs["game"]["ball_real"] < 76) && (LWSave.Prefs["game"]["ball_real"] > 1):
		animation_player.play("ToStart")
	else:
		animation_player.play("ToOver")
	##
##
