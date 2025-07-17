extends "res://scripts/deck.gd"

@onready var card_grid_reference = $"../Backlog"
@onready var card_database_reference = preload("res://scripts/event_database.gd")


func _ready() -> void:
	CARD_COUNT = 9
	ALL_CARDS_GRAPHICS = card_database_reference.ALL_EVENT_CARDS_GRAPHICS
	ALL_CARDS_EFFECTS = card_database_reference.ALL_EVENT_CARDS_EFFECTS
	ALL_CARDS_TEXT = card_database_reference.ALL_EVENT_CARDS_TEXT
	
	var card_names = ALL_CARDS_EFFECTS.keys()
	var reversed_card_names = [] # we need to reverse, because otherwise the last card would be rendered first
	for i in range(card_names.size() - 1, -1, -1):
		reversed_card_names.append(card_names[i])

	for card_name in reversed_card_names:
		var card_scene = preload(CARD_SCENE_PATH)
		var new_card = card_scene.instantiate()
		
		new_card.name = card_name
		new_card.type = new_card.CardType.EVENT
		new_card.effects = ALL_CARDS_EFFECTS[card_name]

		new_card.get_node("CardImage").texture = load(ALL_CARDS_GRAPHICS["front"][0])
		new_card.get_node("CardImage").get_node("FrontText").text = ALL_CARDS_TEXT[card_name][0]
		new_card.get_node("CardImage").get_node("TypeText").text = "Event"
		new_card.get_node("CardImage").get_node("IterationText").text = str(card_names.find(card_name) + 1)
		new_card.get_node("CardImage").get_node("EffectImage").visible = false
		new_card.get_node("CardImage").get_node("StorypointText").visible = false
		new_card.get_node("CardBackImage").texture = load(ALL_CARDS_GRAPHICS["back"][0])
		new_card.get_node("CardBackImage").get_node("BackText").text = ALL_CARDS_TEXT[card_name][1]
		new_card.get_node("CardBackImage").get_node("EffectText").text = ALL_CARDS_TEXT[card_name][2]
		new_card.get_node("CardBackImage").get_node("TypeText").text = "Event"
		new_card.get_node("CardBackImage").z_index = -1
		new_card.position = get_node("Area2D").position
		self.add_child(new_card)
		CARDS_IN_DECK.append(new_card)
