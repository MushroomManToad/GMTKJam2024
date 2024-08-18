class_name IPushableObject

extends CharacterBody2D

@export var SPEED = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var updated_vel : Vector2 = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x += updated_vel.x
	if updated_vel == Vector2(0,0):
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	updated_vel = Vector2(0, 0)

func update_velocity(amount : Vector2):
	updated_vel += amount
