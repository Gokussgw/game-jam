extends Control
const OptionsMenu = preload("res://scenes/OptionsMenu.gd")

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")




func _on_quit_pressed():
	get_tree().quit()

func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/Options_Menu.tscn")
