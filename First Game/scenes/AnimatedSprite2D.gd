extends Control

@onready var animated_sprite = $AnimatedSprite2D

# Store the original size and scale of the animated sprite
var original_size = Vector2(1280, 720)  # Replace with your game's base resolution
var original_scale = Vector2.ONE

func _ready():
	# Store the original scale of the sprite
	original_scale = animated_sprite.scale
	
	# Connect to the size_changed signal of the viewport	get_viewport().connect("size_changed", Callable(self, "_on_size_changed"))
	
	# Ensure the sprite scales when entering fullscreen mode
	_on_fullscreen_toggled()  # Call this to set the initial scale based on the current fullscreen state

func _input(event):
	# Listen for the fullscreen toggle action (e.g., pressing F11)
	if event is InputEventKey and event.pressed and event.scancode == KEY_F11:
		toggle_fullscreen()

func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	_on_fullscreen_toggled()

func _on_fullscreen_toggled():
	# Scale the sprite based on whether the window is fullscreen or not
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		var current_size = DisplayServer.window_get_size()
		var scale_factor = current_size / original_size
		animated_sprite.scale = original_scale * scale_factor
	else:
		animated_sprite.scale = original_scale

func _on_size_changed():
	# Ensure the sprite scales properly when the window size changes
	_on_fullscreen_toggled()
