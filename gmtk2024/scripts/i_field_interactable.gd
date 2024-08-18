class_name IFieldInteractable

extends CharacterBody2D

var is_in_field : bool = false

func _physics_process(delta: float) -> void:
	if is_in_field:
		_in_field_loop(delta)
	else:
		_out_field_loop(delta)

# Loop when in a field
func _in_field_loop(delta : float) -> void:
	pass

# Loop when out of a field
func _out_field_loop(delta : float) -> void:
	pass

func set_in_field(val : bool) -> void:
	is_in_field = val
