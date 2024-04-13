extends Control

@onready var pm_continue = $PauseMenu_Holder/MarginContainer/PauseMenu/PM_VBoxContainer/PM_HBoxContainer/PM_VBoxContainer/PM_Continue
@onready var pm_options = $PauseMenu_Holder/MarginContainer/PauseMenu/PM_VBoxContainer/PM_HBoxContainer/PM_VBoxContainer/PM_Options
@onready var pm_leave = $PauseMenu_Holder/MarginContainer/PauseMenu/PM_VBoxContainer/PM_HBoxContainer/PM_VBoxContainer/PM_Leave

@onready var main_menu = preload("res://scenes/menus/Hub_Menu.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pm_leave.button_down.connect(on_leave_pressed)

func on_leave_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)
