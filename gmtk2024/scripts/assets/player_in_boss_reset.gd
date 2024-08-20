extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.is_in_final_boss:
			body.is_in_final_boss = false
			queue_free()
