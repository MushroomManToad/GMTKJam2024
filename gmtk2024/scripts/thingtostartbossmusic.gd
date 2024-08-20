extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(Game_Manager.game as Game).play_boss_music()
		Game_Manager.player.camera_2d.limit_bottom = (Game_Manager.loaded_floors[1] as GameManager.Floor).get_vals()[0][1] - 64.0
		queue_free()
