class_name Player

extends CharacterBody2D

@export var SPEED : float
@export var JUMP_VELOCITY : float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D

var camera_zoom : bool = false

func _process(delta: float) -> void:
	if not camera_zoom and Input.is_action_pressed("Zoom"):
		camera_zoom_out()
	if camera_zoom and not Input.is_action_pressed("Zoom"):
		camera_zoom_reset()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("Left", "Right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Play Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func camera_zoom_out() -> void:
	camera_zoom = true
	camera_2d.zoom = Vector2(1.0, 1.0)
	pass

func camera_zoom_reset() -> void:
	camera_zoom = false
	camera_2d.zoom = Vector2(3.0, 3.0)
	pass
