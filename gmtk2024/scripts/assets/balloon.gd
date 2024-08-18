extends IFieldInteractable

@export var default_launch_vel : float = 1000.0
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	collision_shape_2d.disabled = true

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var launch_dir : Vector2 = (body.global_position - Vector2(0.0, 6.0)) - self.global_position
		launch_dir = launch_dir.normalized()
		
		var size_modifier : float = 1.0
		if grow_active > 0:
			size_modifier = 2.0
		
		launch_dir = launch_dir * default_launch_vel * size_modifier
		
		body.add_extra_velocity(launch_dir)
	pass # Replace with function body.
