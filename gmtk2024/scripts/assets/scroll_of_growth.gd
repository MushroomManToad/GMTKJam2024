extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collision_shape_2d.set_deferred("disabled", true)
		body.spells_handler.unlock_spell("grow")
		# Play animation that ends in queue_free
		animation_player_2.play("Collect")
