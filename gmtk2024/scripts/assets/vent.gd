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
