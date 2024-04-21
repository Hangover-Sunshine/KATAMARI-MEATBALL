extends Control

@onready var splash_menu = $SplashMenu
@onready var main_menu = $MainMenu
@onready var options_menu = $OptionsMenu

var opened_before = false

var soundtrack_sound_pool

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_open()
	handle_connecting_signals()
	get_tree().paused = false
	
	# Options
	if !("load" in LWSave.Prefs.keys()):
		LWSave.Prefs["load"] = true
		LWSave.Prefs["OS"] = OS.get_name()
		if FileAccess.file_exists("user://options.json"):
			LWSave.load_from_disk("user://options.json")
			
			# Bordered windowed by default
			if LWSave.Prefs["windowed"] == false:
				# game only has 1 window
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			##
		else:
			LWSave.Prefs["windowed"] = true
			LWSave.Prefs["master_vol"] = 0.8
			LWSave.Prefs["music_vol"] = 1
			LWSave.Prefs["sfx_vol"] = 1
			
			# Bindings
			LWSave.Prefs["bindings"] = {}
			
			LWSave.save_to_disk("user://options.json", ["load"])
		##
	##
##

func late_ready():
	soundtrack_sound_pool.fade_in_menu()
##

#Managing which menu is visible 
func _input(event):
	if event.is_pressed() and splash_menu.visible == true:
		$Meatball_Animation.play("Left2Right")
		$PageTransition_Animation.play("Splash2Menu")

func menu_open():
	if opened_before == false:
		$PageTransition_Animation.play("Fade2Splash")
		splash_menu.visible = true
		main_menu.visible = false
		options_menu.visible = false
	else:
		splash_menu.visible = false
		main_menu.visible = true
		options_menu.visible = false

func show_options():
	$Meatball_Animation.play("Right2Left")
	$PageTransition_Animation.play("Menu2Options")
	$OptionsMenu.load_data()
##

func leave_options():
	$Meatball_Animation.play("Left2Right")
	$PageTransition_Animation.play("Options2Menu")

#Handling signal connection for options
func handle_connecting_signals() -> void:
	main_menu.goto_options_menu.connect(show_options)
	options_menu.leave_options_menu.connect(leave_options)
