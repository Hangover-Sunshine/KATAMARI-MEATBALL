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
