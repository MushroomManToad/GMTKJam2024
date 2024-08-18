class_name MimicEnemy

extends CharacterBody2D

@export var SPEED : float
@export var JUMP_VELOCITY : float

@onready var sprite_2d: Sprite2D = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta : float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("Left", "Right")
	
	if Input.is_action_just_pressed("Up"):
		velocity.y = JUMP_VELOCITY
	
	# Flip the Sprite
	if direction > 0:
		sprite_2d.flip_h = false
	elif direction < 0:
		sprite_2d.flip_h = true
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
