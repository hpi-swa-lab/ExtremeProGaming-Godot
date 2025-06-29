extends "res://scripts/deck.gd"

const CARD_COUNT = 27
const CARD_SCENE_PATH = "res://scenes/card.tscn"
var CARDS_IN_DECK = []
@export var START_CARDS = []
signal cards_ready

@onready var card_grid_reference = $"../Backlog"
@onready var card_database_reference = preload("res://scripts/card_database.gd")


func _ready() -> void:
	var card_names = card_database_reference.ALL_FEATURE_CARDS_META.keys()
	card_names.shuffle()
	var selected_names = card_names.slice(0, CARD_COUNT)
	var reversed_names = selected_names.duplicate()
	reversed_names.reverse()

	for name in reversed_names:
		var card_scene = preload(CARD_SCENE_PATH)
		var new_card = card_scene.instantiate()
		
		new_card.name = name
		new_card.storypoints = card_database_reference.ALL_FEATURE_CARDS_META[name][0]
		new_card.area = card_database_reference.ALL_FEATURE_CARDS_META[name][1]
		new_card.count_for_debt_calculation = card_database_reference.ALL_FEATURE_CARDS_META[name][2]
		new_card.is_start_card = card_database_reference.ALL_FEATURE_CARDS_META[name][3]
		new_card.type = new_card.CardType.FEATURE
		new_card.effects = card_database_reference.ALL_FEATURE_CARDS_BACK_META[name]
		var effect_type = card_database_reference.ALL_FEATURE_CARDS_META[name][4]

		var new_card_front_image_path = card_database_reference.ALL_FEATURE_CARDS[new_card.area][0]
		var new_card_back_image_path = card_database_reference.ALL_FEATURE_CARDS[new_card.area][1]
		var new_card_effect_image_path = card_database_reference.ALL_FEATURE_CARDS[effect_type][0]
		
		new_card.get_node("CardImage").texture = load(new_card_front_image_path)
		new_card.get_node("CardImage").get_node("EffectImage").texture = load(new_card_effect_image_path)
		new_card.get_node("CardImage").get_node("FrontText").text = card_database_reference.ALL_FEATURE_CARDS_TEXT[name][0]
		new_card.get_node("CardImage").get_node("TypeText").text = "Feature"
		new_card.get_node("CardImage").get_node("IterationText").visible = false
		new_card.get_node("CardImage").get_node("StorypointText").text = str(new_card.storypoints)
		
		new_card.get_node("CardBackImage").texture = load(new_card_back_image_path)
		new_card.get_node("CardBackImage").get_node("TypeText").text = "Feature"
		new_card.get_node("CardBackImage").get_node("BackText").text = card_database_reference.ALL_FEATURE_CARDS_TEXT[name][1]
		new_card.get_node("CardBackImage").get_node("EffectText").text = card_database_reference.ALL_FEATURE_CARDS_TEXT[name][2]
		new_card.get_node("CardBackImage").z_index = -1
		new_card.position = get_node("Area2D").position
		self.add_child(new_card)
		if new_card.is_start_card == true:
			START_CARDS.append(new_card)
		else:
			
			CARDS_IN_DECK.append(new_card)
	emit_signal("cards_ready")
		
	
func draw_card():
	var card_drawn = CARDS_IN_DECK.back() # the last generated card in rendered on top
	CARDS_IN_DECK.erase(card_drawn)
	
	if CARDS_IN_DECK.size() == 0:
		$Area2D/CollisionShape2D.disabled = true

	$DrawCardSound.play()
	return card_drawn
