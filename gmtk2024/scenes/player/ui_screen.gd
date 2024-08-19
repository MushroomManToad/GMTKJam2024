class_name UI_Screen

extends CanvasLayer

var player : Player

@onready var spell_selector: TextureRect = $"MainGameUI/Spell UI/SpellSelector"

const SPELL_SELECTION_1_1 = preload("res://sprites/ui/spell selection1_1.png")
const SPELL_SELECTION_2_1 = preload("res://sprites/ui/spell selection2_1.png")
const SPELL_SELECTION_2_2 = preload("res://sprites/ui/spell selection2_2.png")
const SPELL_SELECTION_3_1 = preload("res://sprites/ui/spell selection3_1.png")
const SPELL_SELECTION_3_2 = preload("res://sprites/ui/spell selection3_2.png")
const SPELL_SELECTION_3_3 = preload("res://sprites/ui/spell selection3_3.png")
const SPELL_SELECTION = preload("res://sprites/ui/spell selection.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game_Manager.spell_update.connect(_on_spell_update)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_spell_update():
	if player.spells_handler.rotate_unlocked:
		match player.spells_handler.selected_spell:
			"grow":
				spell_selector.texture = SPELL_SELECTION_3_1
			"stretch":
				spell_selector.texture = SPELL_SELECTION_3_2
			"rotate":
				spell_selector.texture = SPELL_SELECTION_3_3
	elif player.spells_handler.stretch_unlocked:
		match player.spells_handler.selected_spell:
			"grow":
				spell_selector.texture = SPELL_SELECTION_2_1
			"stretch":
				spell_selector.texture = SPELL_SELECTION_2_2
	else:
		spell_selector.texture = SPELL_SELECTION_1_1
	pass
