class_name GameOver
extends Control

@onready var go_retry = $MarginContainer/GameOver/GO_Stats_Container/GO_HBoxContainer/GO_Retry
@onready var go_leave = $MarginContainer/GameOver/GO_Stats_Container/GO_HBoxContainer/GO_Leave

@onready var go_stats_container = $MarginContainer/GameOver/GO_Stats_Container
@onready var go_succ_container = $MarginContainer/GameOver/GO_Succ_Container
@onready var go_title_succ = $MarginContainer/GameOver/GO_Stats_Container/GO_Title_Succ
@onready var go_title_fail = $MarginContainer/GameOver/GO_Stats_Container/GO_Title_Fail

var winner = true

func _ready():
	gameover_visibility()
	go_retry.button_down.connect(on_retry_pressed)
	go_leave.button_down.connect(on_leave_pressed)
	GlobalSignals.connect("scene_loaded", _scene_loaded)
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

# Button functionality for stats page
func on_retry_pressed() -> void:
	GlobalSignals.emit_signal("load_scene", "MainLevel")

func on_leave_pressed() -> void:
	GlobalSignals.emit_signal("load_scene", "Menus/Hub_Menu")

# Rules for page switching
func on_cont_pressed() -> void:
	go_succ_container.visible = false
	go_stats_container.visible = true

func gameover_visibility():
	if LWSave.Prefs["winner"] == true:
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
		
