extends "res://scripts/deck.gd"

signal cards_ready
@export var START_CARDS = []

@onready var card_database_reference = preload("res://scripts/feature_database.gd")

var card_grid_reference

func _ready() -> void:
	if InputRecorder.is_restoring:
		return
	else:
		initialize_new_game()

func initialize_new_game():
	card_grid_reference = $"../Backlog"

	CARD_COUNT = 27
	ALL_CARDS_GRAPHICS = card_database_reference.ALL_FEATURE_CARDS_GRAPHICS
	ALL_CARDS_META = card_database_reference.ALL_FEATURE_CARDS_META
	ALL_CARDS_EFFECTS = card_database_reference.ALL_FEATURE_CARDS_EFFECTS
	ALL_CARDS_TEXT = card_database_reference.ALL_FEATURE_CARDS_TEXT
	
	var cards = generate_card_names()
	for card_name in cards:
		var new_card = instatiate_new_card(card_name)
		new_card.type = new_card.CardType.FEATURE
		create_card_front(new_card, "Feature")
		create_card_back(new_card, "Feature")
		new_card.position = get_node("Area2D").position
		self.add_child(new_card)
		if new_card.is_start_card == true:
			START_CARDS.append(new_card)
		else:
			CARDS_IN_DECK.append(new_card)
			
	emit_signal("cards_ready")
