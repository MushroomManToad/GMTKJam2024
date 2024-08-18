class_name IPushableObject

extends IFieldInteractable

@export var SPEED = 60

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var updated_vel : Vector2 = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x += updated_vel.x
	velocity.y += updated_vel.y
	if updated_vel.x == 0.0:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if abs(velocity.x) > SPEED:
		velocity.x = clamp(velocity.x, -SPEED, SPEED)
	move_and_slide()
	updated_vel = Vector2(0, 0)

func update_velocity(amount : Vector2):
	updated_vel = updated_vel + amount

func _get_top() -> float:
	return 0.0

func _get_bottom() -> float:
	return 0.0
