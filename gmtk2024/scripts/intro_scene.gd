extends CanvasLayer

@onready var rumble: AudioStreamPlayer2D = $Rumble

func play_rumble():
	rumble.play()

func load_real_game():
	Game_Manager.load_playable_game()
	queue_free()
