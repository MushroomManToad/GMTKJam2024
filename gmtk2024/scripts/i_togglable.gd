class_name ITogglable

extends Node2D

var power : int = 0

func _physics_process(_delta : float):
	print(power)

func _on_toggle() -> void:
	pass

# For handling number of buttons holding door open
func _add_power(val : int):
	power = power + val
