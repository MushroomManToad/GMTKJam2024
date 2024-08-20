class_name OneWayPlatform

extends Node2D

@onready var one_way: NinePatchRect = $OneWay
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready() -> void:
	var line_ = SegmentShape2D.new()
	line_.a = Vector2(one_way.position[0], -9.0)
	line_.b = Vector2(one_way.position[0] + one_way.size[0], -9.0)
	collision_shape_2d.set_deferred("shape", line_)
