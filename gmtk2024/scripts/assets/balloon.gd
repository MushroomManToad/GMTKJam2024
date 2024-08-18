extends IFieldInteractable



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var launch_dir : Vector2 = body.global_position - self.global_position
	pass # Replace with function body.
