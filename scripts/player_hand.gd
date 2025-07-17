extends Node2D


func move_card_to_backlog(backlog, card):
	move_card_to_cardslot(backlog, card)
	card.z_index = 2
	card.back_flip_card()
	await get_tree().create_timer(1.0).timeout
	
func move_card_to_cardslot(backlog, card):
	var start_pos = card.global_position
	var next_free_card_slot = backlog.get_next_free_card_slot()
	if next_free_card_slot:
		var end_pos = next_free_card_slot.global_position

		card.z_index = 3
		card.get_parent().remove_child(card)
		next_free_card_slot.card_reference.add_child(card)
		card.scale = Vector2.ONE
		card.global_position = start_pos

		var tween := get_tree().create_tween()
		tween.tween_property(card, "global_position", end_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		next_free_card_slot.is_card_in_slot = true
		card.on_card_grid = true
		await tween.finished
		return card
	else:
		return null

func move_card_to_discard_pile(card, pile):
	var start_pos = card.global_position
	card.get_parent().remove_child(card)
	pile.card_reference.add_child(card)
	card.z_index = 5
	card.global_position = start_pos

	var end_pos = pile.global_position
	var tween := get_tree().create_tween()
	tween.tween_property(card, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "global_position", end_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func move_storypoints_to_debt(supply, debt):
	var storypoints_in_supply = supply.storypoints_reference.get_children()
	storypoints_in_supply.sort_custom(func(a, b): return a.position.x < b.position.x)
	var selected_storypoint = storypoints_in_supply[0]

	var old_global_position = selected_storypoint.global_position
	supply.storypoints_reference.remove_child(selected_storypoint)
	debt.storypoints_reference.add_child(selected_storypoint)
	selected_storypoint.global_position = old_global_position
	selected_storypoint.scale = Vector2.ONE

	var tween = get_tree().create_tween()
	tween.tween_property(selected_storypoint, "global_position", debt.global_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func move_storypoints_to_card(supply, card, needed_storypoints):
	var storypoints_in_supply = supply.storypoints_reference.get_children()
	storypoints_in_supply.sort_custom(func(a, b): return a.position.x < b.position.x)
	var selected_storypoints = storypoints_in_supply.slice(0, needed_storypoints)

	for sp in selected_storypoints:
		var start_pos = sp.global_position
		supply.storypoints_reference.remove_child(sp)
		card.storypoints_reference.add_child(sp)
		sp.scale = Vector2.ONE
		sp.global_position = start_pos

	# get all storypoints currently on the card
	var all_storypoints = card.storypoints_reference.get_children()
	var count = all_storypoints.size()
	var spacing = 40.0
	var total_width = (count - 1) * spacing
	var start_x = card.global_position.x - total_width / 2
	var y_pos = card.global_position.y

	# position them centered on the card
	for i in range(count):
		var sp = all_storypoints[i]
		var target_x = start_x + i * spacing
		var target_pos = Vector2(target_x, y_pos)

		var tween = get_tree().create_tween()
		tween.tween_property(sp, "global_position", target_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func move_storypoints_to_supply(supply, card_or_debt):
	var storypoints_on_card = card_or_debt.storypoints_reference.get_children()
		
	for sp in storypoints_on_card:
		sp.z_index = 5
		var start_pos = sp.global_position
		var end_pos = sp.original_position
		card_or_debt.storypoints_reference.remove_child(sp)
		supply.storypoints_reference.add_child(sp)
		sp.global_position = start_pos
		
		var tween := get_tree().create_tween()
		tween.tween_property(sp, "global_position", end_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
func move_cards_to_front(chosen_cards, chosen_debt):
	var screen_size = get_viewport_rect().size
	var screen_center = screen_size / 2
	
	var card_count = chosen_cards.size()
	var card_spacing = 400
	var total_card_width = (card_count - 1) * card_spacing
	
	for i in range(card_count):
		var card = chosen_cards[i]
		card.z_index = 8
		card.scale = Vector2(1.0, 1.0)
		var tween = create_tween()
		var x_offset = -total_card_width / 2 + i * card_spacing
		var target_pos = screen_center + Vector2(x_offset, 50)
		tween.tween_property(card, "global_position", target_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(card, "scale", Vector2(1.5, 1.5), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	if chosen_debt != null and chosen_debt.size() > 0:
		var debt_count = chosen_debt.size()
		var debt_spacing = 150 
		var total_debt_width = (debt_count - 1) * debt_spacing
		var debt_y_position = screen_size.y * 0.2  # position debt at 20% from top
		
		for i in range(debt_count):
			var debt = chosen_debt[i]
			debt.z_index = 8
			var tween = create_tween()
			var x_offset = -total_debt_width / 2 + i * debt_spacing
			var target_pos = Vector2(screen_center.x + x_offset, debt_y_position)
			tween.tween_property(debt, "global_position", target_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			
func remove_cheapest_feature(backlog, discard_pile, effect_value):
	var cards = backlog.get_cheapest_feature_effect(effect_value)
	for cheapest_card in cards:
		cheapest_card.get_parent().get_parent().is_card_in_slot = false
		await move_card_to_discard_pile(cheapest_card, discard_pile)
		
func feature_with_storypoints_x_is_implemented(backlog, discard_pile, effect_value):
	var possible_card = backlog.get_card_with_storypoints(effect_value)
	if possible_card != null:
		move_card_to_discard_pile(possible_card, discard_pile)
		
func draw_features(feature_deck, backlog, effect_value):
	var drawn_cards = []
	for i in range(0, effect_value):
		var drawn_card = feature_deck.draw_card()
		drawn_card.z_index = 5
		drawn_cards.append(drawn_card)
		await move_card_to_cardslot(backlog, drawn_card)
	return drawn_cards
		
func draw_bug(bug_deck, backlog, effect_value):
	for i in range(0, effect_value):
		var card = bug_deck.draw_card()
		move_card_to_cardslot(backlog, card)
