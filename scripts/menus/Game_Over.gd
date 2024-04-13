class_name GameOver
extends Control

@onready var go_retry = $MarginContainer/GameOver/GO_Stats_Container/GO_HBoxContainer/GO_Retry
@onready var go_leave = $MarginContainer/GameOver/GO_Stats_Container/GO_HBoxContainer/GO_Leave

@onready var go_stats_container = $MarginContainer/GameOver/GO_Stats_Container
@onready var go_succ_container = $MarginContainer/GameOver/GO_Succ_Container
@onready var go_title_succ = $MarginContainer/GameOver/GO_Stats_Container/GO_Title_Succ
@onready var go_title_fail = $MarginContainer/GameOver/GO_Stats_Container/GO_Title_Fail

@onready var start_level = preload("res://scenes/MainScene.tscn") as PackedScene
@onready var main_menu = preload("res://scenes/menus/Hub_Menu.tscn") as PackedScene

var winner = true
# Called when the node enters the scene tree for the first time.

func _ready():
	gameover_visibility()
	go_retry.button_down.connect(on_retry_pressed)
	go_leave.button_down.connect(on_leave_pressed)

# Read any button input to continue for success page
func _input(event):
	if event.is_pressed() and go_succ_container.visible == true:
		on_cont_pressed()

# Button functionality for stats page
func on_retry_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_leave_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)

# Rules for page switching
func on_cont_pressed() -> void:
	go_succ_container.visible = false
	go_stats_container.visible = true

func gameover_visibility():
	if winner == true:
		go_succ_container.visible = true
		go_stats_container.visible = false
		go_title_succ.visible = true
		go_title_fail.visible = false
	else:
		go_succ_container.visible = false
		go_stats_container.visible = true
		go_title_succ.visible = false
		go_title_fail.visible = true
		
