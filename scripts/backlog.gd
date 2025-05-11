extends Node2D
const CARD_SLOT_SCENE_PATH = "res://scenes/card_slot.tscn"
const CARD_SLOT_COUNT = 9

func _ready() -> void:
	var card_slot_scene = preload(CARD_SLOT_SCENE_PATH)

	var columns = 3
	var rows = 3
	var slot_width = 200
	var slot_height = 250
	var spacing = 10 
	var start_pos = Vector2(600.0, 175.0)

	for i in range(CARD_SLOT_COUNT):
		var col = i % columns
		var row = i / columns

		var x = start_pos.x + col * (slot_width + spacing)
		var y = start_pos.y + row * (slot_height + spacing)

		var new_card_slot = card_slot_scene.instantiate()
		new_card_slot.name = "CardSlot_%d" % i
		new_card_slot.position = Vector2(x, y)
		 
		add_child(new_card_slot)
		
		get_next_free_card_slot()
		
func get_next_free_card_slot() -> Node2D:
	var slots = get_children()
	
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

	for slot in get_children():
		for child in slot.get_children():
			if child.has_method("is_card") and child.chosen:
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
