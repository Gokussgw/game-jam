extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_MusicArea_body_entered"))
	connect("body_exited", Callable(self, "_on_MusicArea_body_exited"))

# Function to handle the body entering the Area2D
func _on_MusicArea_body_entered(body):
	if body is CharacterBody2D or body is RigidBody2D or body is Area2D:
		$AudioStreamPlayer.play()

# Function to handle the body exiting the Area2D
func _on_MusicArea_body_exited(body):
	if body is CharacterBody2D or body is RigidBody2D or body is Area2D:
		$AudioStreamPlayer.stop()
