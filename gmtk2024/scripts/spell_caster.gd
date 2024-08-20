class_name SpellCaster

extends Area2D

var destination : Vector2 = Vector2(0 , 0)
var direction : Vector2 = Vector2(0 , 0)
var speed : float = 10.0

var spell : String = "none"

const FIELD = preload("res://scenes/assets/player_field.tscn")

var player : Player

func _physics_process(_delta: float) -> void:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + direction * speed, 0b00000000_00000000_00000000_01011111, [self])
	var result = space_state.intersect_ray(query)
	if result.size() == 0:
		# If it would pass the destination, stop and spawn the field there.
		if (destination - (global_position + direction * speed))[1] * (destination - global_position)[1] <= 0:
			spawn_field(destination)
		else:
			self.global_position += direction * speed
	else:
		# Unless destination is closer than contact point.
		if abs(destination - global_position) < abs(result.position - global_position):
			spawn_field(destination)
		else:
			# Take contact position and spawn field there.
			spawn_field(result.position)

func spawn_field(pos : Vector2):
	# Spawn Field
	var field_instance : Field = FIELD.instantiate()
	field_instance.global_position = pos
	match spell:
		"grow":
			field_instance.type_grow = true
		"stretch":
			field_instance.type_stretch = true
		"rotate":
			field_instance.type_rotate = true
	Game_Manager.game.add_child(field_instance)
	
	# Update the player's active spell
	if not player.spells_handler.active_grow_field == null:
		player.spells_handler.active_grow_field.queue_free()
	if not player.spells_handler.active_stretch_field == null:
		player.spells_handler.active_stretch_field.queue_free()
	if not player.spells_handler.active_rotate_field == null:
		player.spells_handler.active_rotate_field.queue_free()
	match spell:
		"grow":
			player.spells_handler.active_grow_field = field_instance
		"stretch":
			player.spells_handler.active_stretch_field = field_instance
		"rotate":
			player.spells_handler.active_rotate_field = field_instance
	
	# Remove the traveller
	queue_free()

func set_direction(dir : Vector2):
	direction = dir

func set_spell(spell_id : String):
	spell = spell_id

func set_destination(des: Vector2):
	destination = des
