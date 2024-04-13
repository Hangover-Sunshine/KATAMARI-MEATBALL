class_name OptionsMenu
extends Control

@onready var o_leave = $MarginContainer/OptionsMenu/O_VBoxContainer/O_LEAVE as Button

signal leave_options_menu

func _ready():
	o_leave.button_down.connect(on_back_pressed)

func on_back_pressed() -> void:
	leave_options_menu.emit()
