extends "res://scripts/deck.gd"

var START_CARDS = []
signal cards_ready

@onready var card_grid_reference = $"../Backlog"
@onready var card_database_reference = preload("res://scripts/bug_database.gd")


func _ready() -> void:
	if InputRecorder.is_restoring:
		return
	CARD_COUNT = 12
	ALL_CARDS_GRAPHICS = card_database_reference.ALL_BUG_CARDS_GRAPHICS
	ALL_CARDS_META = card_database_reference.ALL_BUG_CARDS_META
	ALL_CARDS_EFFECTS = card_database_reference.ALL_BUG_CARDS_EFFECTS
	ALL_CARDS_TEXT = card_database_reference.ALL_BUG_CARDS_TEXT
	
	var cards = generate_card_names()
	for card_name in cards:
		var new_card = instatiate_new_card(card_name)
		new_card.type = new_card.CardType.BUG
		create_card_front(new_card, "Bug")
		create_card_back(new_card, "Bug")
		new_card.position = get_node("Area2D").position
		self.add_child(new_card)
		if new_card.is_start_card == true:
			START_CARDS.append(new_card)
		else:
			CARDS_IN_DECK.append(new_card)
	emit_signal("cards_ready")
