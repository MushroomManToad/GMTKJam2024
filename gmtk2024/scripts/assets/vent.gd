extends Node2D

@export var height : float

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Resize the vent blowy range
	collision_shape_2d.position[1] = -(height * 16.0) / 2.0
	
	var rect = RectangleShape2D.new()
	rect.extents = Vector2(5.0, height * 8.0)
	collision_shape_2d.shape = rect

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).vent_count = (body as Player).vent_count + 1
	if body is IPushableObject:
		pass

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		(body as Player).vent_count = (body as Player).vent_count - 1
	if body is IPushableObject:
		pass
