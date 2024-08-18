extends Area2D

@export var door : KeyDoor
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

var to_door_vector : Vector2 = Vector2(0, 0)
var collecting : bool = false
var collecting_timer : float = 0.0

func _ready():
	pass

func _process(delta: float) -> void:
	if collecting:
		if not to_door_vector.length_squared() > 0:
			to_door_vector = door.door_center_sprite.global_position - self.global_position
		self.global_position += to_door_vector * delta
		collecting_timer += delta
		if collecting_timer >= 1.0:
			open_door()
		if collecting_timer >= 5.0:
			self.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collect_key()

func collect_key():
	collecting = true
	collision_shape_2d.set_deferred("disabled", true)

func open_door():
	if door.is_closed:
		door._on_toggle()
	sprite_2d.visible = false
	cpu_particles_2d.emitting = false
