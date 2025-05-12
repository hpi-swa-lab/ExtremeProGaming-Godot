extends Node2D

@onready var feature_deck = $"../FeatureDeck"
@onready var event_deck = $"../EventDeck"
@onready var backlog = $"../Backlog"
@onready var supply = $"../Supply"
@onready var label = $"../GameNotifications"
@onready var discard_pile = $"../DiscardPile"
@onready var event_discard_pile = $"../EventDiscardPile"
@onready var iteration = 1
@onready var current_phase


enum Phase {
	DRAW_EVENT,
	DRAW_FEATURE,
	PLAN,
	END
}

func _ready():
	label.text = "[center][font_size=24]Draw cards![/font_size][/center]"
	prepare_iteration()
	
func prepare_iteration():
	current_phase = Phase.DRAW_EVENT
	label.text = ("The current interation is: " + str(iteration) + ". Please draw 1 Event Card.")
	
func plan_iteration():
	current_phase = Phase.PLAN
	label.text = ("Now plan your iteration. You can draw more cards or place select Cards for this iteration.")
	
func _on_start_iteration_button_down() -> void:
	lighten_background()
	$"../StartIterationButton".visible = false
	var chosen_cards = backlog.get_chosen_cards()
	for card in chosen_cards:
		var card_slot = card.get_parent()
		card_slot.is_card_in_slot = false
		card_slot.card_in_slot = null
		card.choose_card() # we execute this to make the card unusable in that state
		move_card_to_discard_pile(card, discard_pile)
		
	iteration += 1
	prepare_iteration()
	
func _on_end_interation_button_down() -> void:
	current_phase = Phase.END
	var chosen_cards = backlog.get_chosen_cards()
	for card in chosen_cards:
		card.flip_card()
		move_storypoints_to_supply(card)

	darken_background()
	move_cards_to_front(chosen_cards)
	$"../StartIterationButton".visible = true
	
func _process(delta):
	if backlog.no_cards_chosen():
		$"../EndInterationButton".disabled = true
	else:
		$"../EndInterationButton".disabled = false
	
	
func darken_background():
	$"../DarkenedBackground".visible = true
	$"../DarkenedBackground".z_index = 3
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 0.5, 0.5) # fade in
	
func lighten_background():
	$"../DarkenedBackground".visible = false
	$"../DarkenedBackground".z_index = 3
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 0.5, 0.5) # fade in
	
func move_cards_to_front(chosen_cards):
	var card_count = chosen_cards.size()
	var screen_size = Vector2(1920, 1080) #get_viewport_rect().size
	var screen_center = screen_size / 2
	var spacing = 500  # Space between cards

	# Calculate total width of all cards
	var total_width = (card_count - 1) * spacing

	for i in range(card_count):
		var card = chosen_cards[i]
		card.z_index = 4
		var tween = create_tween()

		var x_offset = -total_width / 2 + i * spacing
		var target_pos = screen_center + Vector2(x_offset, 0)

		tween.tween_property(card, "global_position", target_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(card, "scale", Vector2(2, 2), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)



func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var card = raycast_check_for_card()
		if not card:
			return

		match current_phase:
			Phase.DRAW_EVENT:
				if event_card_can_be_drawn(event, card):
					var drawn_card = event_deck.draw_card()
					darken_background()
					move_cards_to_front([drawn_card])
					await get_tree().create_timer(2.0).timeout
					drawn_card.flip_card()
					await get_tree().create_timer(2.0).timeout
					lighten_background()
					move_card_to_discard_pile(drawn_card, event_discard_pile)
					drawn_card.z_index = -1
					current_phase = Phase.DRAW_FEATURE
					label.text = ("Please draw at least 1 Feature Card.")
			Phase.DRAW_FEATURE:
				if feature_card_can_be_drawn(event, card):
					var drawn_card = feature_deck.draw_card()
					move_card_to_cardslot(drawn_card)
					plan_iteration()

			Phase.PLAN:
				var needed_storypoints = card.storypoints
				if feature_card_can_be_drawn(event, card):
					var drawn_card = feature_deck.draw_card()
					move_card_to_cardslot(drawn_card)
				elif card_can_be_choosen(event, card, needed_storypoints):
					card.choose_card()
					move_storypoints_to_card(card)
				elif card_can_be_unchoosen(event, card):
					card.choose_card()
					move_storypoints_to_supply(card)

					
func card_can_be_choosen(event, card, needed_storypoints):
	return event.pressed and not card.uncovered and card.on_card_grid and card.chosen == false and needed_storypoints <= available_storypoints() and card.type == card.CardType.FEATURE
	
func card_can_be_unchoosen(event, card):
	return event.pressed and not card.uncovered and card.on_card_grid and card.chosen and card.type == card.CardType.FEATURE
	
func feature_card_can_be_drawn(event, card):
	return event.pressed and not card.uncovered and !card.on_card_grid and card.type == card.CardType.FEATURE
	
func event_card_can_be_drawn(event, card):
	return event.pressed and not card.uncovered  and card.type == card.CardType.EVENT


func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var card_candidate = result[0].collider.get_parent()
		if card_candidate is Card:
			return card_candidate
	else:
		return null

func move_card_to_cardslot(card):
	var start_pos = card.global_position  # capture before reparenting
	var next_free_card_slot = backlog.get_next_free_card_slot()
	if next_free_card_slot:
		var end_pos = next_free_card_slot.global_position

		card.get_parent().remove_child(card)
		next_free_card_slot.add_child(card)
		card.global_position = start_pos

		var tween := get_tree().create_tween()
		tween.tween_property(card, "global_position", end_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		next_free_card_slot.is_card_in_slot = true
		next_free_card_slot.card_in_slot = card
		card.on_card_grid = true
		return card
	else:
		return null
		
		
func move_card_to_discard_pile(card, pile):
	var start_pos = card.global_position
	card.get_parent().remove_child(card)
	pile.add_child(card)
	card.global_position = start_pos

	var end_pos = pile.global_position

	var tween := get_tree().create_tween()
	tween.tween_property(card, "scale", Vector2(0.8, 0.8), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "global_position", end_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func available_storypoints():
	var storypoints_in_supply = supply.storypoints_reference.get_children()
	return storypoints_in_supply.size()
		
func move_storypoints_to_card(card):
	var needed_storypoints = card.storypoints
	var storypoints_in_supply = supply.storypoints_reference.get_children()
	storypoints_in_supply.sort_custom(func(a, b): return a.position.x < b.position.x)
	var selected_storypoints = storypoints_in_supply.slice(0, needed_storypoints)
	
	for sp in selected_storypoints:
		var start_pos = sp.global_position
		var end_pos = card.global_position
		
		supply.storypoints_reference.remove_child(sp)
		card.storypoints_reference.add_child(sp)
		sp.global_position = start_pos
		
		# Animate to new position
		var tween := get_tree().create_tween()
		tween.tween_property(sp, "global_position", end_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
func move_storypoints_to_supply(card):

	var storypoints_on_card = card.storypoints_reference.get_children()
		
	for sp in storypoints_on_card:
		var start_pos = sp.global_position
		var end_pos = sp.original_position
		card.storypoints_reference.remove_child(sp)
		supply.storypoints_reference.add_child(sp)
		sp.global_position = start_pos
		
		var tween := get_tree().create_tween()
		tween.tween_property(sp, "global_position", end_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
