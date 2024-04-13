extends Control

@onready var splash_menu = $SplashMenu
@onready var main_menu = $MainMenu
@onready var options_menu = $OptionsMenu

var opened_before = false

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_open()
	handle_connecting_signals()

func _input(event):
	if event.is_pressed() and splash_menu.visible == true:
		splash_menu.visible = false
		main_menu.visible = true

func menu_open():
	if opened_before == false:
		splash_menu.visible = true
		main_menu.visible = false
		options_menu.visible = false
	else:
		splash_menu.visible = false
		main_menu.visible = true
		options_menu.visible = false

func handle_connecting_signals() -> void:
	main_menu.goto_options_menu.connect(show_options)
	options_menu.leave_options_menu.connect(leave_options)
	
func show_options():
	splash_menu.visible = false
	main_menu.visible = false
	options_menu.visible = true

func leave_options():
	splash_menu.visible = false
	main_menu.visible = true
	options_menu.visible = false
