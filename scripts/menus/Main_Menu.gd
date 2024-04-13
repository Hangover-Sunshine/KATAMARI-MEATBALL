class_name MainMenu
extends Control

@onready var mm_start = $MarginContainer/MainMenu/MM_VBoxContainer/MM_HBoxContainer/MM_VBoxContainer/MM_Start
@onready var mm_options = $MarginContainer/MainMenu/MM_VBoxContainer/MM_HBoxContainer/MM_VBoxContainer/MM_Options
@onready var mm_leave = $MarginContainer/MainMenu/MM_VBoxContainer/MM_HBoxContainer/MM_VBoxContainer/MM_Exit
@onready var start_level = preload("res://scenes/MainScene.tscn") as PackedScene

signal goto_options_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	handle_connecting_signals()

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_options_pressed() -> void:
	goto_options_menu.emit()

func on_exit_pressed() -> void:
	get_tree().quit()

func handle_connecting_signals() -> void:
	mm_start.button_down.connect(on_start_pressed)
	mm_options.button_down.connect(on_options_pressed)
	mm_leave.button_down.connect(on_exit_pressed)
	pass
