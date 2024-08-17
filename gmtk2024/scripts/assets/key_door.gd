class_name KeyDoor

extends ITogglable

var is_closed : bool = true

var power : int = 0

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

func open_door():
	is_closed = false
	collision_shape_2d.disabled = true

func close_door():
	is_closed = true

func _on_toggle():
	if is_closed:
		open_door()
	else:
		close_door()

# For handling number of buttons holding door open
func add_power(val : int):
	power = power + val
	if is_closed and val > 0:
		open_door()
	elif not is_closed and val <= 0:
		val = 0
		close_door()
