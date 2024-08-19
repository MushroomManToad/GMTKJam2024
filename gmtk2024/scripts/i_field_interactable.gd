class_name IFieldInteractable

extends CharacterBody2D

var grow_active : int = 0
var stretch_active : int = 0
var rotate_active : int = 0

func _physics_process(delta: float) -> void:
	if active_fields_total() > 0:
		_in_field_loop(delta)
	else:
		_out_field_loop(delta)

# Loop when in a field
func _in_field_loop(_delta : float) -> void:
	pass

# Loop when out of a field
func _out_field_loop(_delta : float) -> void:
	pass

func _on_field_update() -> void:
	pass

func active_fields_total() -> int:
	return grow_active + stretch_active + rotate_active

# Fields, "grow", "stretch", "rotate"
func add_field(field_name : String):
	match field_name:
		"grow":
			grow_active = grow_active + 1
		"stretch":
			stretch_active = stretch_active + 1
		"rotate":
			rotate_active = rotate_active + 1

func remove_field(field_name : String):
	match field_name:
		"grow":
			grow_active = grow_active - 1
		"stretch":
			stretch_active = stretch_active - 1
		"rotate":
			rotate_active = rotate_active - 1
