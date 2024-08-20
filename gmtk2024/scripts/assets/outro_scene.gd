extends CanvasLayer

@onready var rumble: AudioStreamPlayer2D = $Rumble

func load_real_game():
	var title_instance = Game_Manager.TITLE.instantiate()
	Game_Manager.game.add_child(title_instance)
	queue_free()
