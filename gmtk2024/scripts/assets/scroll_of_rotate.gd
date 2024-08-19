extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collision_shape_2d.set_deferred("disabled", true)
		body.spells_handler.unlock_spell("grow")
		body.spells_handler.unlock_spell("stretch")
		body.spells_handler.unlock_spell("rotate")
		# Play animation that ends in queue_free
