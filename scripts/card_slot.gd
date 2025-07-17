extends Node2D

@onready var is_card_in_slot = false
@onready var card_reference = $Cards

func get_all_features():
	var features = 0
	for card in card_reference.get_children():
		if card.type == card.CardType.FEATURE:
			features +=1
	return features
	
func get_all_bugs():
	var finished_bugs = 0
	for card in card_reference.get_children():
		if card.type == card.CardType.BUG:
			finished_bugs += 1
	return finished_bugs
	
func get_features_in_area(area):
	var finished_features = 0
	for card in card_reference.get_children():
		if card.type == card.CardType.FEATURE:
			if card.area == area:
				finished_features += 1
	return finished_features
	
func get_bugs_in_area(area):
	var finished_bugs = 0
	for card in card_reference.get_children():
		if card.type == card.CardType.BUG:
			if card.area == area:
				finished_bugs += 1
	return finished_bugs
