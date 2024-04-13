class_name MainMenu
extends Control

@onready var mm_play = $MarginContainer/MainMenu/MM_VBoxContainer/MM_HBoxContainer/MM_VBoxContainer/MM_PLAY
@onready var mm_options = $MarginContainer/MainMenu/MM_VBoxContainer/MM_HBoxContainer/MM_VBoxContainer/MM_OPTIONS
@onready var mm_leave = $MarginContainer/MainMenu/MM_VBoxContainer/MM_HBoxContainer/MM_VBoxContainer/MM_LEAVE
@onready var start_level = preload("res://scenes/MainScene.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	mm_play.button_down.connect(on_play_pressed)
	mm_leave.button_down.connect(on_exit_pressed)

func on_play_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_exit_pressed() -> void:
	get_tree().quit()
