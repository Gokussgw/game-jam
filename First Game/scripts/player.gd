extends CharacterBody2D

# Exported variables to adjust jump parameters
@export var max_hold_time: float = 1.0  # Maximum time the jump button can be held
@export var min_jump_force: float = 200.0  # Minimum jump force
@export var max_jump_force: float = 800.0  # Maximum jump force
@export var custom_gravity: float = 1200.0  # Custom gravity value for manual application
@export var speed: float = 400.0  # Horizontal movement speed
@onready var audio_stream_player_2d = $Area2D/CollisionShape2D/AudioStreamPlayer2D

var jump_timer: float = 0.0
var is_jumping: bool = false
var can_move: bool = true  # Control movement when not aiming a jump
var jump_direction: Vector2 = Vector2.UP  # Initial direction to jump in

# Onready variable to access the Line2D node for jump aiming
@onready var jump_aim_indicator = $JumpAimIndicator as Line2D

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_jump_aim()  # Ensure the jump aim indicator is not visible at start

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	handle_input(delta)
	apply_custom_gravity(delta)
	if can_move:
		move_and_slide()

# Handle input for movement and jumping
func handle_input(delta: float):
	var horizontal_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	if is_on_floor():
		if can_move:
			velocity.x = horizontal_input * speed  # Set horizontal velocity based on input

		if Input.is_action_pressed("jump"):
			if not is_jumping:
				jump_timer = 0.0
				is_jumping = true
				can_move = false  # Disable movement while aiming
			jump_timer = min(jump_timer + delta, max_hold_time)
			
			# Calculate the jump direction within the specified angle range
			var angle = clamp(horizontal_input, -0.5, 0.5) * 40.0  # Clamp input to get angles between -30 to 30 degrees
			jump_direction = Vector2(sin(deg_to_rad(angle)), -cos(deg_to_rad(angle))).normalized()
			
			show_jump_aim(jump_direction)  # Show aiming indicator based on current direction
			update_jump_aim(jump_direction, jump_timer)  # Update indicator based on hold time

		if Input.is_action_just_released("jump"):
			if is_jumping:
				var jump_force = min_jump_force + (max_jump_force - min_jump_force) * (jump_timer / max_hold_time)
				jump_force = min(jump_force, max_jump_force)
				velocity = jump_direction * jump_force  # Apply force in the aimed direction
			is_jumping = false
			can_move = true  # Enable movement after jump
			hide_jump_aim()

# Manually apply gravity to the player
func apply_custom_gravity(delta: float):
	if not is_on_floor():
		velocity.y += custom_gravity * delta  # Apply custom gravity if not on ground

# Show and update jump aiming indicator
func show_jump_aim(direction: Vector2):
	jump_aim_indicator.visible = true

func update_jump_aim(direction: Vector2, timer: float):
	jump_aim_indicator.points = [Vector2.ZERO, direction * (50 + timer * 150)]  # Increase the indicator length with timer

func hide_jump_aim():
	jump_aim_indicator.visible = false



func _on_area_2d_body_entered(body):
	audio_stream_player_2d.play()
