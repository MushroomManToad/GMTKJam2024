extends Area2D

@export var door : KeyDoor
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var to_door_vector : Vector2
var collecting : bool = false
var collecting_timer : float = 0.0

func _ready():
	to_door_vector = door.global_position - self.global_position

func _process(delta: float) -> void:
	if collecting:
		self.global_position += to_door_vector * delta
		collecting_timer += delta
		if collecting_timer >= 1.0:
			open_door()

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body is Player:
		collect_key()

func collect_key():
	collecting = true
	collision_shape_2d.disabled = true

func open_door():
	if door.is_closed:
		door._on_toggle()
	self.queue_free()
