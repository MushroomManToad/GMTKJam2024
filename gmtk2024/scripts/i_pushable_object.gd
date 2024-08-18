class_name IPushableObject

extends IFieldInteractable

@export var SPEED = 60

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var updated_vel : Vector2 = Vector2(0, 0)

var vent_count : int = 0

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if not is_on_floor() and vent_count == 0:
		velocity.y += gravity * delta
	if vent_count > 0 and velocity.y > 0:
		velocity.y = 0
	velocity.x += updated_vel.x
	velocity.y += updated_vel.y
	if updated_vel.x == 0.0:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if abs(velocity.x) > SPEED:
		velocity.x = clamp(velocity.x, -SPEED, SPEED)
	move_and_slide()
	updated_vel = Vector2(0, 0)
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is Player:
			var c_ = c.get_collider() as Player
			var ypos = c_.global_position[1] + 1.0
			if ypos > _get_bottom() + 8.0:
				if c_.global_position[0] < self.global_position.x:
					self.update_velocity(Vector2(self.SPEED, -4.0))
				else:
					self.update_velocity(Vector2(-self.SPEED, -4.0))

func update_velocity(amount : Vector2):
	updated_vel = updated_vel + amount

func _get_top() -> float:
	return 0.0

func _get_bottom() -> float:
	return 0.0
