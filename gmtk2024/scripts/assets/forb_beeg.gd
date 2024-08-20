class_name ForbBeeg

extends Area2D

var direction : Vector2
var speed : float

var lifetime : float = 10.0

func _physics_process(delta: float) -> void:
	self.global_position += direction * speed
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.damage()
		queue_free()
