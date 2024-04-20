class_name GameOver
extends Control

@onready var go_retry = $MarginContainer/GameOver/GO_Stats_Container/GO_HBoxContainer/GO_Retry
@onready var go_leave = $MarginContainer/GameOver/GO_Stats_Container/GO_HBoxContainer/GO_Leave

@onready var go_stats_container = $MarginContainer/GameOver/GO_Stats_Container
@onready var go_succ_container = $MarginContainer/GameOver/GO_Succ_Container
@onready var go_title_succ = $MarginContainer/GameOver/GO_Stats_Container/GO_Title_Succ
@onready var go_title_fail = $MarginContainer/GameOver/GO_Stats_Container/GO_Title_Fail

@onready var go_cult_kills = $MarginContainer/GameOver/GO_Stats_Container/GO_HBox_Stats/GO_VBox_Killed/GO_Cultists/GO_Cult_Kills
@onready var go_hero_kills = $MarginContainer/GameOver/GO_Stats_Container/GO_HBox_Stats/GO_VBox_Killed/GO_Heroes/GO_Hero_Kills
@onready var go_civil_kills = $MarginContainer/GameOver/GO_Stats_Container/GO_HBox_Stats/GO_VBox_Killed/GO_Civilians/GO_Civil_Kills
@onready var go_time = $MarginContainer/GameOver/GO_Stats_Container/GO_HBox_Stats/GO_VBox_Travel/GO_Cult_Score/GO_Time
@onready var go_size = $MarginContainer/GameOver/GO_Stats_Container/GO_HBox_Stats/GO_VBox_Travel/GO_Cult_Score3/GO_Size

@onready var go_cult_score = $MarginContainer/GameOver/GO_Stats_Container/GO_HBox_Stats/GO_VBox_KillScore/GO_Cult_Score/GO_Cult_Score
@onready var go_hero_score = $MarginContainer/GameOver/GO_Stats_Container/GO_HBox_Stats/GO_VBox_KillScore/GO_Hero_Score/GO_Hero_Score
@onready var go_civil_score = $MarginContainer/GameOver/GO_Stats_Container/GO_HBox_Stats/GO_VBox_KillScore/GO_Civil_Score/GO_Civil_Score
@onready var go_total_kills = $MarginContainer/GameOver/GO_Stats_Container/GO_TotalScore/GO_Total_Kills

var winner = true

func _ready():
	gameover_visibility()
	go_retry.button_down.connect(on_retry_pressed)
	go_leave.button_down.connect(on_leave_pressed)
	GlobalSignals.connect("scene_loaded", _scene_loaded)
	
	go_cult_kills.text = str(LWSave.Prefs["game"]["cult_roll"])
	go_hero_kills.text = str(LWSave.Prefs["game"]["hero_roll"])
	go_civil_kills.text = str(LWSave.Prefs["game"]["civy_roll"])
	
	var time = LWSave.Prefs["game"]["time"]
	var min:float = 0
	var sec:float = 0
	var ms:float = 0
	
	while time > 60:
		min += 1
		time -= 60
	##
	
	var decimal:String = "%01.2f" % time
	
	go_time.text = str(min) + ":" + decimal
	
	var ball_size:float = LWSave.Prefs["game"]["ball"]
	
	var meters:float = 0
	var leading_zeros:int = 6
	while ball_size > 100:
		meters += 1
		ball_size -= 100
	##
	
	decimal = "%.2f" % ball_size
	var meter_string = "%*d" % [leading_zeros, meters]
	
	go_size.text = meter_string + decimal
	
	go_cult_score.text = str(50 * LWSave.Prefs["game"]["cult_roll"])
	go_hero_score.text = str(100 * LWSave.Prefs["game"]["hero_roll"])
	go_civil_score.text = str(150 * LWSave.Prefs["game"]["hero_roll"])
	go_total_kills.text = str((50 * LWSave.Prefs["game"]["cult_roll"]) +\
							(100 * LWSave.Prefs["game"]["hero_roll"]) +\
							(150 * LWSave.Prefs["game"]["civy_roll"]) +\
							(meters * 10) -\
							(time * 30))
##

func _scene_loaded(new_scene:String):
	if new_scene != name:
		queue_free()
	##
##

# Read any button input to continue for success page
func _input(event):
	if event.is_pressed() and go_succ_container.visible == true:
		on_cont_pressed()
	##
##

# Button functionality for stats page
func on_retry_pressed() -> void:
	GlobalSignals.emit_signal("load_scene", "MainLevel")
##

func on_leave_pressed() -> void:
	GlobalSignals.emit_signal("load_scene", "Menus/Hub_Menu")
##

# Rules for page switching
func on_cont_pressed() -> void:
	go_succ_container.visible = false
	go_stats_container.visible = true

func gameover_visibility():
	if LWSave.Prefs["game"]["winner"] == true:
		go_succ_container.visible = true
		go_stats_container.visible = false
		go_title_succ.visible = true
		go_title_fail.visible = false
		$TextFlash_Player.play("Button_Flash")
	else:
		go_succ_container.visible = false
		go_stats_container.visible = true
		go_title_succ.visible = false
		go_title_fail.visible = true
	##
##
