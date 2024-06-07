extends CharacterBody2D

# Exported variables for physics parameters
@export var max_hold_time: float = 1.0
@export var min_jump_force: float = 200.0
@export var max_jump_force: float = 800.0
@export var custom_gravity: float = 1200.0
@export var speed: float = 400.0
@export var bounce_factor: float = 1.0  # Factor determining how bouncy the collisions are
@onready var music = $Area2D/CollisionShape2D/AudioStreamPlayer
@onready var jump = $AudioStreamPlayer

var jump_timer: float = 0.0
var is_jumping: bool = false
var can_move: bool = true
var jump_direction: Vector2 = Vector2.UP

@onready var jump_aim_indicator = $JumpAimIndicator as Line2D

func _ready():
	hide_jump_aim()

func _physics_process(delta: float):
	handle_input(delta)
	apply_custom_gravity(delta)
	if can_move:
		move_and_slide()
	handle_collisions()

func handle_input(delta: float):
	var horizontal_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	if is_on_floor():
		if can_move:
			velocity.x = horizontal_input * speed

		if Input.is_action_pressed("jump"):
			if not is_jumping:
				jump_timer = 0.0
				is_jumping = true
				can_move = false

			jump_timer = min(jump_timer + delta, max_hold_time)
			var angle = clamp(horizontal_input, -0.5, 0.5) * 50.0
			jump_direction = Vector2(sin(deg_to_rad(angle)), -cos(deg_to_rad(angle))).normalized()
			show_jump_aim(jump_direction)
			update_jump_aim(jump_direction, jump_timer)

		if Input.is_action_just_released("jump"):
			if is_jumping:
				var jump_force = min_jump_force + (max_jump_force - min_jump_force) * (jump_timer / max_hold_time)
				velocity = jump_direction * min(jump_force, max_jump_force)
				jump.play()  # Play jump sound when jump force is applied
			is_jumping = false
			can_move = true
			jump.play()
			hide_jump_aim()

func apply_custom_gravity(delta: float):
	if not is_on_floor():
		velocity.y += custom_gravity * delta

func handle_collisions():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		# Reflect the velocity off the normal with the bounce factor applied
		velocity = velocity.bounce(normal) * bounce_factor

func show_jump_aim(direction: Vector2):
	jump_aim_indicator.visible = true

func update_jump_aim(direction: Vector2, timer: float):
	jump_aim_indicator.points = [Vector2.ZERO, direction * (50 + timer * 150)]

func hide_jump_aim():
	jump_aim_indicator.visible = false


func _on_area_2d_body_entered(body):
	muisc.play()
