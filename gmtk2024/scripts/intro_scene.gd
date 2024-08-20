extends CanvasLayer

func play_rumble():
	pass

func load_real_game():
	Game_Manager.load_playable_game()
	queue_free()
