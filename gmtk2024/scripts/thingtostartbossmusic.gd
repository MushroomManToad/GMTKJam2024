extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if not body.is_in_final_boss:
			(Game_Manager.game as Game).play_boss_music()
			Game_Manager.player.is_in_final_boss = true
			Game_Manager.player.camera_2d.limit_bottom = (Game_Manager.loaded_floors[1] as GameManager.Floor).get_vals()[0][1] - 64.0
			queue_free()
