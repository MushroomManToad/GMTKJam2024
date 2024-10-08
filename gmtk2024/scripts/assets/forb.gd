class_name Forb

extends Area2D

var direction : Vector2
var speed : float

func _physics_process(delta: float) -> void:
	self.global_position += direction * speed

func _on_body_entered(body: Node2D) -> void:
	if not body.get_parent() is OneWayPlatform and not body is Vent:
		if body is Player:
			body.damage()
		queue_free()
