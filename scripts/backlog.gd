extends Node2D
const CARD_SLOT_SCENE_PATH = "res://scenes/card_slot.tscn"
const CARD_SLOT_COUNT = 9
@onready var slots_reference = $Slots

func _ready() -> void:
	var card_slot_scene = preload(CARD_SLOT_SCENE_PATH)

	var columns = 3
	var rows = 3
	var slot_width = 200
	var slot_height = 250
	var spacing = 10 
	var start_pos = slots_reference.position

	for i in range(CARD_SLOT_COUNT):
		var col = i % columns
		var row = int(i / columns) # integer division
		
		var x = start_pos.x + col * (slot_width + spacing)
		var y = start_pos.y + row * (slot_height + spacing)

		var new_card_slot = card_slot_scene.instantiate()
		new_card_slot.name = "CardSlot_%d" % i
		new_card_slot.position = Vector2(x, y)

		slots_reference.add_child(new_card_slot)
		
		get_next_free_card_slot()

		
func get_next_free_card_slot() -> Node2D:
	var slots = slots_reference.get_children()
	
	# Sort by row (y position) first, then by column (x position)
	slots.sort_custom(func(a, b):
		# If y positions are different (different rows)
		if a.position.y != b.position.y:
			return a.position.y < b.position.y
		# Same row, sort by x position
		return a.position.x < b.position.x
	)
	# Find first empty slot
	for slot in slots:
		if not slot.is_card_in_slot:
			return slot
	
	return null
func get_chosen_cards():
	var chosen_cards = []

	for slot in slots_reference.get_children():
		for child in slot.card_reference.get_children():
			if child.has_method("is_card") and child.chosen:
				chosen_cards.append(child)

	return chosen_cards
	
func get_card_with_storypoints(storypoints):
	var chosen_cards = []

	for slot in slots_reference.get_children():
		for child in slot.card_reference.get_children():
			if child.storypoint == storypoints:
				chosen_cards.append(child)
			
	if chosen_cards.size() > 0:
		return chosen_cards[0]
	return null

func get_cheapest_feature_effect(amount):
	var cheapest_card
	var costs = 10000
	var cards = get_all_cards_in_backlog()
	
	cards.sort_custom(
		func(card1, card2):
			return int(card2.storypoints) - int(card1.storypoints)
	)
	return cards.slice(0, amount)
	
func get_all_cards_in_backlog():
	var cards = []
	for slot in slots_reference.get_children():
		for child in slot.card_reference.get_children():
			if child.has_method("is_card"):
				cards.append(child)
	return cards
				
	
func get_chosen_cards_from_area(area):
	var chosen_cards = []

	for slot in slots_reference.get_children():
		for child in slot.card_reference.get_children():
			if child.has_method("is_card") and child.chosen and child.area == area:
				chosen_cards.append(child)

	return chosen_cards
	
func get_card_container() -> Node2D:
	var cards_reference = $Cards
	return cards_reference
	
func no_cards_chosen() -> bool:
	var chosen_cards = get_chosen_cards()
	if chosen_cards.size() == 0:
		return true
	else:
		return false
