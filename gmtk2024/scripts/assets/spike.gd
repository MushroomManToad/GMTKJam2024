extends Node2D

func _on_static_body_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.damage()
