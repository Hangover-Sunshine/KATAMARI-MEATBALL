extends Node

func fade_out_menu():
	$MenuFade.play("fade_out_menu")
##

func fade_in_menu():
	$Menu.play()
	$MenuFade.play("fade_in_menu")
##

func fade_in_game():
	$GamePlay.play()
	$GameFade.play("fade_in_game")
##

func fade_out_game():
	$GameFade.play("fade_out_game")
##

func _on_game_fade_animation_finished(anim_name):
	if anim_name == "fade_out_game":
		$GamePlay.stop()
	##
##

func _on_menu_fade_animation_finished(anim_name):
	if anim_name == "fade_out_game":
		$Menu.stop()
	##
##
