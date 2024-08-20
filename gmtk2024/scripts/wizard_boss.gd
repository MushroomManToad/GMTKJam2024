class_name WizardBoss

extends Node2D

@onready var damage_zone: Area2D = $"Damage Zone"
@onready var explosion: AudioStreamPlayer2D = $"Damage Zone/Explosion"
@onready var explosion_png: ExplosionDotPng = $ExplosionPNG

var health : int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hurt_wizard():
	health -= 1

func _on_damage_zone_body_entered(body: Node2D) -> void:
	if body is Hazard_Crate:
		# Blow up the crate and damage the Wizard
		body.queue_free()
		hurt_wizard()
		explosion.play()
		explosion_png.play_animation()
		pass
