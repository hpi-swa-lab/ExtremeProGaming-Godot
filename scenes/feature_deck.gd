extends "res://scripts/deck.gd"

const CARD_COUNT = 9
const CARD_SCENE_PATH = "res://scenes/card.tscn"
var CARDS_IN_DECK = []

@onready var card_grid_reference = $"../Backlog"
@onready var card_database_reference = preload("res://scripts/card_database.gd")


func _ready() -> void:
	var card_names = card_database_reference.ALL_FEATURE_CARDS.keys()
	card_names.shuffle()
	var selected_names = card_names.slice(0, CARD_COUNT)

	for name in selected_names:
		var card_scene = preload(CARD_SCENE_PATH)
		var new_card = card_scene.instantiate()
		
		new_card.name = name
		new_card.storypoints = card_database_reference.ALL_FEATURE_CARDS_META[name][0]
		new_card.type = new_card.CardType.FEATURE

		var new_card_front_image_path = card_database_reference.ALL_FEATURE_CARDS[name][0]
		var new_card_back_image_path = card_database_reference.ALL_FEATURE_CARDS[name][1]
		new_card.get_node("CardImage").texture = load(new_card_front_image_path)
		new_card.get_node("CardImage").scale = Vector2(0.3, 0.28)
		
		new_card.get_node("CardBackImage").texture = load(new_card_back_image_path)
		new_card.get_node("CardBackImage").scale = Vector2(0.3, 0.3)
		new_card.get_node("CardBackImage").z_index = -1
		new_card.position = get_node("Area2D").position 
		self.add_child(new_card)
		CARDS_IN_DECK.append(new_card)

	
func draw_card():
	var card_drawn = CARDS_IN_DECK[-1]
	CARDS_IN_DECK.erase(card_drawn)
	
	if CARDS_IN_DECK.size() == 0:
		$Area2D/CollisionShape2D.disabled = true

	$DrawCardSound.play()
	return card_drawn
