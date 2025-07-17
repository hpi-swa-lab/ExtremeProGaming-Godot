extends Node2D

@onready var CARD_COUNT
@onready var ALL_CARDS_GRAPHICS
@onready var ALL_CARDS_META
@onready var ALL_CARDS_EFFECTS
@onready var ALL_CARDS_TEXT
var CARDS_IN_DECK = []
const CARD_SCENE_PATH = "res://scenes/card.tscn"


func generate_card_names():
	var card_names = ALL_CARDS_TEXT.keys()
	card_names.shuffle()
	var selected_names = card_names.slice(0, CARD_COUNT)
	var reversed_names = selected_names.duplicate()
	reversed_names.reverse()
	return reversed_names
	
func instatiate_new_card(card_name):
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	new_card.name = card_name
	new_card.storypoints = ALL_CARDS_META[card_name][0]
	new_card.area = ALL_CARDS_META[card_name][1]
	new_card.count_for_debt_calculation = ALL_CARDS_META[card_name][2]
	new_card.is_start_card = ALL_CARDS_META[card_name][3]
	new_card.effects = ALL_CARDS_EFFECTS[card_name]
	return new_card
	
func create_card_front(new_card, card_type):
	new_card.get_node("CardImage").texture = load(ALL_CARDS_GRAPHICS[new_card.area][0])
	var effect_type = ALL_CARDS_META[new_card.name][4]
	new_card.get_node("CardImage").get_node("EffectImage").texture = load(ALL_CARDS_GRAPHICS[effect_type][0])
	set_auto_sized_text(new_card.get_node("CardImage").get_node("FrontText"), ALL_CARDS_TEXT[new_card.name][0])
	new_card.get_node("CardImage").get_node("TypeText").text = card_type
	new_card.get_node("CardImage").get_node("IterationText").visible = false
	new_card.get_node("CardImage").get_node("StorypointText").text = str(new_card.storypoints)


func create_card_back(new_card, card_type):
	new_card.get_node("CardBackImage").texture = load(ALL_CARDS_GRAPHICS[new_card.area][1])
	new_card.get_node("CardBackImage").get_node("TypeText").text = card_type
	set_auto_sized_text(new_card.get_node("CardBackImage").get_node("BackText"), ALL_CARDS_TEXT[new_card.name][1])
	set_auto_sized_text(new_card.get_node("CardBackImage").get_node("EffectText"), ALL_CARDS_TEXT[new_card.name][2])
	new_card.get_node("CardBackImage").z_index = -1
	
	
func set_auto_sized_text(rich_text_label: RichTextLabel, text: String):
	var translation_key = text
	var translated_text = tr(translation_key)
		
	rich_text_label.text = translated_text
	rich_text_label.fit_content = false
	rich_text_label.scroll_active = false
	
	var text_length = translated_text.length()
	var font_size = 70
	if text_length > 90:
		font_size = 55
	
	rich_text_label.add_theme_font_size_override("normal_font_size", font_size)

func draw_card():
	var card_drawn = CARDS_IN_DECK.back() # the last generated card in rendered on top
	CARDS_IN_DECK.erase(card_drawn)
	
	if CARDS_IN_DECK.size() == 0:
		$Area2D/CollisionShape2D.disabled = true

	$DrawCardSound.play()
	return card_drawn
	
func highlight(state):
	get_node("SelectionBorder").visible = state
