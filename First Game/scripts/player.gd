extends CharacterBody2D

class_name Player

const SPEED = 160.0
const JUMP_VELOCITY = -300.0
const MAX_JUMP_VELOCITY = -650.0  # Maximum jump velocity for longer hold
const MAX_JUMP_HOLD_TIME = 0.5  # Maximum time to hold jump button to reach max jump height
const FRICTION = 4000.0  # Friction constant to slow down the player on the ground
const BOUNCE_DAMPENING = 0.8  # Factor to reduce the bounce effect

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
var is_invincible = false
var invincible_time = 2.0  # Time in seconds the player is invincible
var lives = 2  # Player starts with 2 lives
var state = "idle"
var jump_hold_time = 0.0  # Time the jump button is held
var aim_direction = Vector2.ZERO  # Aim direction for jumping

func _ready():
	add_to_group("player")

func _physics_process(delta):
	if state != "dead":
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			# Reset vertical velocity when on the floor
			velocity.y = max(0, velocity.y)

			# Get the input direction: -1, 0, 1
			var direction = Input.get_axis("move_left", "move_right")

			# Set the aim direction based on player input while on the ground
			if direction != 0:
				aim_direction.x = direction
				aim_direction = aim_direction.normalized()

			# Apply friction to horizontal velocity when on the ground and no input is given
			if is_on_floor() and direction == 0:
				if velocity.x > 0:
					velocity.x = max(velocity.x - FRICTION * delta, 0)
				elif velocity.x < 0:
					velocity.x = min(velocity.x + FRICTION * delta, 0)

			# Flip the Sprite
			animated_sprite.flip_h = direction < 0

		# Handle jump start when button is pressed
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump_hold_time = 0.0  # Reset jump hold time

		# Increment jump hold time while the button is held
		if Input.is_action_pressed("jump"):
			jump_hold_time += delta
			jump_hold_time = min(jump_hold_time, MAX_JUMP_HOLD_TIME)  # Clamp the hold time to the maximum

		# Apply jump velocity when the button is released
		if Input.is_action_just_released("jump") and is_on_floor():
			var jump_force = lerp(JUMP_VELOCITY, MAX_JUMP_VELOCITY, jump_hold_time / MAX_JUMP_HOLD_TIME)
			velocity.y = jump_force
			velocity.x = aim_direction.x * SPEED  # Apply horizontal velocity based on aim direction

		# Play animations
		if state != "dead":
			if is_on_floor():
				if velocity.x == 0:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("run")
			else:
				animated_sprite.play("jump")

		# Flickering effect when invincible
		if is_invincible:
			# Make the sprite flicker by altering visibility
			visible = !visible

		# Apply movement and detect collisions
		move_and_slide()

		# Check for collisions to implement wall bouncing
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			if abs(collision.get_normal().x) > 0.9 and not is_on_floor():  # Horizontal collision detected while in air
				velocity.x = -velocity.x * BOUNCE_DAMPENING  # Reverse and dampen horizontal velocity to bounce off the wall
				break  # Exit the loop once a bounce is detected to avoid multiple reversals

func get_hit():
	if is_invincible:
		# If hit while invincible, the player dies
		die()
	else:
		# Become invincible after first hit
		is_invincible = true
		var timer = get_tree().create_timer(invincible_time)
		await timer.timeout
		end_invincibility()

func end_invincibility():
	# Reset invincibility state and make sure player is visible
	is_invincible = false
	visible = true

func die():
	if lives > 1:
		lives -= 1
		# Become invincible after losing a life
		get_hit()
	else:
		# Play death animation and wait for it to finish before reloading the scene
		state = "dead"
		animated_sprite.play("Death")  # Make sure "Death" is the name of your death animation
		velocity = Vector2.ZERO
		var timer = get_tree().create_timer(2.0)
		await timer.timeout
		print("Reloading scene")
		get_tree().reload_current_scene()  # Reload the current scene to restart the game
