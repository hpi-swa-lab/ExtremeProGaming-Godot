extends Node2D

@onready var is_card_in_slot = false
@onready var card_reference = $Cards

func get_all_features():
	var features = 0
	for card in card_reference.get_children():
		if card.type == card.CardType.FEATURE:
			features +=1
	return features
