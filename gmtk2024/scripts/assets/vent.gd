class_name Vent

extends Node2D

@export var height : float
@export var SPEED : float = -10.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

var pushable_bodies_to_float : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Resize the vent blowy range
	collision_shape_2d.position[1] = -(height * 16.0) / 2.0 - 9.0
	
	var rect = RectangleShape2D.new()
	rect.extents = Vector2(5.0, height * 8.0)
	collision_shape_2d.shape = rect
	
	cpu_particles_2d.lifetime = height * 0.5
	cpu_particles_2d.amount = height * 8 + 16

func _physics_process(delta: float) -> void:
	for b in pushable_bodies_to_float:
		(b as IPushableObject).update_velocity(Vector2(0.0, SPEED))

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).vent_count = (body as Player).vent_count + 1
	if body is IPushableObject:
		body.vent_count += 1
		pushable_bodies_to_float.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		(body as Player).vent_count = (body as Player).vent_count - 1
	if body is IPushableObject:
		body.vent_count -= 1
		pushable_bodies_to_float.erase(body)
