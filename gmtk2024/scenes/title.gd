extends Control

const CREDITS = preload("res://scenes/Credits.tscn")

#play button
func _on_play_pressed() -> void:
	Game_Manager.start_game()
#settings
func _on_settings_pressed() -> void:
	pass # Replace with function body.
#credits
func _on_credits_pressed() -> void:
	var credits_instance = CREDITS.instantiate()
	Game_Manager.game.add_child(credits_instance)
	
