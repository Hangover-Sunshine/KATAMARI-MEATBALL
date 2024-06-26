class_name OptionsMenu
extends Control

@export var SFXPool:SoundPool

@onready var o_leave = $MarginContainer/OptionsMenu/O_VBoxContainer/O_LEAVE as Button

@onready var o_overall_slider = $MarginContainer/OptionsMenu/O_VBoxContainer/Overall_Volume/O_OverallSlider
@onready var o_fx_slider = $MarginContainer/OptionsMenu/O_VBoxContainer/FX_Volume/O_FXSlider
@onready var o_music_slider = $MarginContainer/OptionsMenu/O_VBoxContainer/Music_Volume/O_MusicSlider

@onready var o_fx_percent = $MarginContainer/OptionsMenu/O_VBoxContainer/FX_Volume/O_FXPercent
@onready var o_music_percent = $MarginContainer/OptionsMenu/O_VBoxContainer/Music_Volume/O_MusicPercent
@onready var o_overall_percent = $MarginContainer/OptionsMenu/O_VBoxContainer/Overall_Volume/O_OverallPercent

@onready var window_mode_2 = $MarginContainer/OptionsMenu/O_VBoxContainer/WindowMode2

signal leave_options_menu

func _ready():
	o_leave.button_down.connect(on_back_pressed)
##

func load_data():
	# if OS is web, hide resolution size -- full screen or whatever we decide is default only
	if LWSave.Prefs["OS"] == "Web":
		window_mode_2.process_mode = Node.PROCESS_MODE_DISABLED
		window_mode_2.visible = false
	##
	
	print(LWSave.Prefs["sfx_vol"])
	o_fx_slider.value = LWSave.Prefs["sfx_vol"] * 100
	o_fx_percent.text = str(o_fx_slider.value) + "%"
	o_music_slider.value = LWSave.Prefs["music_vol"] * 100
	o_music_percent.text = str(o_music_slider.value) + "%"
	o_overall_slider.value = LWSave.Prefs["master_vol"] * 100
	o_overall_percent.text = str(o_overall_slider.value) + "%"
##

func on_back_pressed() -> void:
	LWSave.save_to_disk("user://options.json", ["game", "load", "OS"])
	leave_options_menu.emit()
##

func _on_o_overall_slider_value_changed(value):
	o_overall_percent.text = str(value) + "%"
	LWSave.Prefs["master_vol"] = value / 100
	var master = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master, linear_to_db(LWSave.Prefs["master_vol"]))
##

func _on_o_fx_slider_value_changed(value):
	o_fx_percent.text = str(value) + "%"
	LWSave.Prefs["sfx_vol"] = value  / 100
	var sfx = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx, linear_to_db(LWSave.Prefs["sfx_vol"]))
##

func _on_o_music_slider_value_changed(value):
	o_music_percent.text = str(value) + "%"
	LWSave.Prefs["music_vol"] = value / 100
	var music = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music, linear_to_db(LWSave.Prefs["music_vol"]))
##

func _on_o_window_check_box_toggled(toggled_on):
	LWSave.Prefs["windowed"] = toggled_on
	
	if LWSave.Prefs["windowed"] == false:
		# game only has 1 window
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	##
##

func _on_o_leave_mouse_entered():
	SFXPool.play_random_sound()
##
