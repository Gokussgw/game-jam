extends Node2D

const FOLLOW_SPEED = 100.0

var player : Node2D = null

@onready var detection_area = $DetectionArea

func _ready():
	if detection_area == null:
		print("Error: DetectionArea node not found!")
	else:
		detection_area.connect("player_detected", Callable(self, "_on_player_detected"))
		detection_area.connect("player_lost", Callable(self, "_on_player_lost"))
		print("Detection area connections established.")

func _process(delta):
	if player != null:
		follow_player(delta)
		print("Player detected. Enemy is running.")

func follow_player(delta):
	var player_pos = player.global_position
	print("Following player at position: ", player_pos)
	if global_position.distance_to(player_pos) >= 10:  # Follow player if not too close
		var direction = (player_pos - global_position).normalized()
		global_position += direction * FOLLOW_SPEED * delta
		print("Moving enemy to position: ", global_position)
	else:
		print("Player is too far. Enemy stops moving.")

func _on_player_detected(player_body):
	player = player_body
	print("Player detected: ", player)

func _on_player_lost(player_body):
	player = null
	print("Player lost")
