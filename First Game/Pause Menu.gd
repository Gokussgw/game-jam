extends Control

@onready var optionsMenu = preload("res://scenes/OptionsMenu.gd")

func _ready():
	$AnimationPlayer.play("RESET")
	hide_pause_menu()

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	hide_pause_menu()

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	show_pause_menu()

func show_pause_menu():
	visible = true

func hide_pause_menu():
	visible = false

func testEsc():
	if Input.is_action_just_pressed("esc"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	get_tree().paused = false  # Ensure the game is unpaused
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _process(delta):
	testEsc()
