class_name WizardBoss

extends Node2D

@onready var damage_zone: Area2D = $"Damage Zone"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_damage_zone_body_entered(body: Node2D) -> void:
	print(body)
	if body is Hazard_Crate:
		# Blow up the crate and damage the Wizard
		print("BOOM!")
		pass
