extends Control

@onready var pm_continue = $PauseMenu_Holder/MarginContainer/PauseMenu/PM_VBoxContainer/PM_HBoxContainer/PM_VBoxContainer/PM_Continue
@onready var pm_options = $PauseMenu_Holder/MarginContainer/PauseMenu/PM_VBoxContainer/PM_HBoxContainer/PM_VBoxContainer/PM_Options
@onready var pm_leave = $PauseMenu_Holder/MarginContainer/PauseMenu/PM_VBoxContainer/PM_HBoxContainer/PM_VBoxContainer/PM_Leave

@onready var pause_menu_holder = $PauseMenu_Holder
@onready var options_menu = $OptionsMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pm_leave.button_down.connect(on_leave_pressed)
	pm_options.button_down.connect(on_options_pressed)
	handle_connecting_signals()

#Scene switching
func on_leave_pressed() -> void:
	GlobalSignals.emit_signal("load_scene", "Menus/Hub_Menu")

#Managing which menu is visible
func on_options_pressed():
	pause_menu_holder.visible = false
	options_menu.visible = true

func back_to_pause():
	pause_menu_holder.visible = true
	options_menu.visible = false

#Handling signal connection for options
func handle_connecting_signals() -> void:
	options_menu.leave_options_menu.connect(back_to_pause)
