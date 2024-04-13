extends Control

@onready var go_retry = $MarginContainer/MainMenu/PM_VBoxContainer/GO_HBoxContainer/GO_Retry
@onready var go_leave = $MarginContainer/MainMenu/PM_VBoxContainer/GO_HBoxContainer/GO_Leave

@onready var start_level = preload("res://scenes/MainScene.tscn") as PackedScene
@onready var main_menu = preload("res://scenes/menus/Hub_Menu.tscn") as PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	go_retry.button_down.connect(on_retry_pressed)
	go_leave.button_down.connect(on_leave_pressed)

func on_retry_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_leave_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)

