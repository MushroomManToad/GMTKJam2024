extends Node2D

@export var to_toggle : ITogglable

var pressed : int = 0

func send_activation_signal():
	to_toggle._add_power(1)

func send_deactivation_signal():
	to_toggle._add_power(-1)

func _on_detection_region_body_entered(body: Node2D) -> void:
	if body is Player or body is IPushableObject:
		if pressed == 0:
			send_activation_signal()
		pressed = pressed + 1


func _on_detection_region_body_exited(body: Node2D) -> void:
	if body is Player or body is IPushableObject:
		pressed = pressed - 1
	if pressed == 0:
		send_deactivation_signal()
