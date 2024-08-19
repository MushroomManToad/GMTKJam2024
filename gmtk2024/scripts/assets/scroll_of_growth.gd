extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collision_shape_2d.disabled = true
		body.spells_handler.grow_unlocked = true
		body.spells_handler.selected_spell = "grow"
		# Play animation that ends in queue_free
