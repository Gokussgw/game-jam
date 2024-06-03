extends CharacterBody2D

# Movement speed
@export var speed : float = 100.0
var player_position : Vector2
var target_position : Vector2
# Get a reference to the player. It's likely different in your project
@onready var player : Node2D = get_parent().get_parent().get_node("Player")

func _physics_process(delta: float) -> void:
	# Set player_position to the position of the player node
	player_position = player.global_position
	# Calculate the direction to the player
	target_position = (player_position - global_position).normalized()
	
	# Check if the enemy is in a 3px range of the player, if not move to the target position
	if global_position.distance_to(player_position) > 3:
		velocity = target_position * speed
	else:
		velocity = Vector2.ZERO

	# Move the enemy
	move_and_slide()
