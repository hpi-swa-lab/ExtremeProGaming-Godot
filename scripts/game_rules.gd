extends Node2D

@onready var feature_deck = $"../FeatureDeck"
@onready var event_deck = $"../EventDeck"
@onready var bug_deck = $"../BugDeck"
@onready var backlog = $"../Backlog"
@onready var techical_debt_account = $"../TechnicalDebtAccount"
@onready var supply = $"../Supply"
@onready var label = $"../GameNotifications"
@onready var discard_pile = $"../DiscardPile"
@onready var event_discard_pile = $"../EventDiscardPile"
@onready var choose_sp_or_debt_label = $"../ChooseSPorDebtLabel"
@onready var canvas_layer = $"../CanvasLayer"
@onready var iteration = 1
@onready var current_phase
var event_card_drawn_once = false


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
	event_card_drawn_once = false
	current_phase = Phase.DRAW_EVENT
	label.text = ("The current interation is: " + str(iteration) + ". Please draw 1 Event Card.")
	
func plan_iteration():
	current_phase = Phase.PLAN
	label.text = ("Now plan your iteration. You can draw more cards or place select Cards for this iteration.")
	
func _on_read_event_button_down(drawn_card) -> void:
	get_tree().paused = true
	lighten_background()
	move_card_to_discard_pile(drawn_card, event_discard_pile)
	drawn_card.z_index = -2
	current_phase = Phase.DRAW_FEATURE
	for child in canvas_layer.get_children():
		child.queue_free()
	await get_tree().create_timer(2.0).timeout
	execute_card_effect(drawn_card)
	label.text = ("Please draw at least 1 Feature Card.")
	get_tree().paused = false
	
func _on_start_iteration_button_down() -> void:
	for child in canvas_layer.get_children():
		child.queue_free()
		
	lighten_background()
	var chosen_cards = backlog.get_chosen_cards()
	for card in chosen_cards:
		var card_slot = card.get_parent()
		card_slot.is_card_in_slot = false
		card_slot.card_in_slot = null
		card.choose_card() # we execute this to make the card unusable in that state
		move_card_to_discard_pile(card, discard_pile)
	techical_debt_account.remove_refactored_debt()
	var needed_debt = calculate_technical_debt(chosen_cards)
	techical_debt_account.add_debt_after_round(needed_debt)
		
	await get_tree().create_timer(2.0).timeout
	for sp in supply.storypoints_reference.get_children():
		sp.self_destroy -= 1
		if sp.self_destroy <= 0:
			sp.queue_free()
		else:
			supply.STORYPOINTS -= 1
	for card in chosen_cards:
		if card.cannot_be_unchosen == false:
			execute_card_effect(card)
	iteration += 1
	prepare_iteration()
	
		
	
func _on_end_interation_button_down() -> void:
	current_phase = Phase.END
	var chosen_cards = backlog.get_chosen_cards()
	var chosem_debt = techical_debt_account.get_all_debt_selected_for_refactoring()
	for card in chosen_cards:
		card.flip_card()
		move_storypoints_to_supply(card)
	for debt in chosem_debt:
		move_storypoints_to_supply(debt)

	darken_background()
	move_cards_to_front(chosen_cards, chosem_debt)
	
	var start_iteration_button = create_button("Start new iteration", Vector2(880.0, 947.0), 5)
	start_iteration_button.connect("button_down", func(): _on_start_iteration_button_down())
	
func _process(delta):
	if backlog.no_cards_chosen() and techical_debt_account.no_debt_selected():
		$"../EndInterationButton".disabled = true
	else:
		$"../EndInterationButton".disabled = false
	
func darken_background():
	$"../DarkenedBackground".visible = true
	var tween = create_tween()
	tween.tween_property($"../ColorRect", "modulate:a", 0.5, 0.5) # fade in
	
func lighten_background():
	$"../DarkenedBackground".visible = false
	var tween = create_tween()
	tween.tween_property($"../ColorRect", "modulate:a", 0.5, 0.5) # fade in
	
func move_cards_to_front(chosen_cards, chosen_debt):
	var screen_size = get_viewport_rect().size
	var screen_center = screen_size / 2
	
	var card_count = chosen_cards.size()
	var card_spacing = 500
	var total_card_width = (card_count - 1) * card_spacing
	
	for i in range(card_count):
		var card = chosen_cards[i]
		card.z_index = 5
		var tween = create_tween()
		var x_offset = -total_card_width / 2 + i * card_spacing
		var target_pos = screen_center + Vector2(x_offset, 50)
		tween.tween_property(card, "global_position", target_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(card, "scale", Vector2(2, 2), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	if chosen_debt != null and chosen_debt.size() > 0:
		var debt_count = chosen_debt.size()
		var debt_spacing = 150 
		var total_debt_width = (debt_count - 1) * debt_spacing
		var debt_y_position = screen_size.y * 0.2  # Position debt at 20% from top
		
		for i in range(debt_count):
			var debt = chosen_debt[i]
			debt.z_index = 5
			var tween = create_tween()
			var x_offset = -total_debt_width / 2 + i * debt_spacing
			var target_pos = Vector2(screen_center.x + x_offset, debt_y_position)
			tween.tween_property(debt, "global_position", target_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var candidate = raycast_check_for_object()
		var card = null
		var debt = null
		if candidate is Card:
			card = candidate
		if candidate is TechnicalDebt:
			debt = candidate

		match current_phase:
			Phase.DRAW_EVENT:
				if card and not event_card_drawn_once and event_card_can_be_drawn(event, card):
					event_card_drawn_once = true
					var drawn_card = event_deck.draw_card()
					darken_background()
					move_cards_to_front([drawn_card], null)
					await get_tree().create_timer(2.0).timeout
					drawn_card.flip_card()
					
					var event_button = create_button("I read and understood the event", Vector2(880.0, 947.0), 5)
					event_button.connect("button_down", func(): _on_read_event_button_down(drawn_card))
			Phase.DRAW_FEATURE:
				if card and feature_card_can_be_drawn(event, card):
					var drawn_card = feature_deck.draw_card()
					move_card_to_cardslot(drawn_card)
					plan_iteration()

			Phase.PLAN:
				if card:
					var needed_storypoints = card.storypoints + techical_debt_account.calculate_needed_storypoints(card.area)
					if card and feature_card_can_be_drawn(event, card):
						var drawn_card = feature_deck.draw_card()
						move_card_to_cardslot(drawn_card)
					elif card and card_can_be_choosen(event, card, needed_storypoints):
						card.choose_card()
						move_storypoints_to_card(card, needed_storypoints)
					elif card and card_can_be_unchoosen(event, card):
						card.choose_card()
						move_storypoints_to_supply(card)
						techical_debt_account.remove_technical_debt(card)
				elif debt and debt_can_be_refactored(event, debt):
					debt.to_be_refectored = true
					move_storypoints_to_debt(debt)
				elif debt and debt_can_be_unchoosen(event, debt):
					debt.to_be_refectored = false
					move_storypoints_to_supply(debt)
					
func calculate_technical_debt(choosen_cards):
	var frontend = 0
	var backend = 0
	for card in choosen_cards:
		if card.area == "backend" and card.count_for_debt_calculatiom == true:
			backend += 1
		if card.area == "frontend" and card.count_for_debt_calculatiom == true:
			frontend += 1
	
	if backend > 0:
		backend = 1
	if frontend > 0:
		frontend = 1
		
	return {"backend": backend, "frontend": frontend}
	
func card_can_be_choosen(event, card, needed_storypoints):
	if techical_debt_account.get_currently_refactored_debt_for_area(card.area) != 0:
		label.text = ("You can select cards in "+ card.area + " if you have no debt to be refactored from "+ card.area)
	return event.pressed and not card.uncovered and card.on_card_grid and card.chosen == false and needed_storypoints <= supply.available_storypoints() and (card.type == card.CardType.FEATURE or card.type == card.CardType.BUG) and techical_debt_account.get_currently_refactored_debt_for_area(card.area) == 0 
	
func card_can_be_unchoosen(event, card):
	return event.pressed and not card.uncovered and card.on_card_grid and card.chosen and (card.type == card.CardType.FEATURE or card.type == card.CardType.BUG) and card.cannot_be_unchosen == false
	
func feature_card_can_be_drawn(event, card):
	return event.pressed and not card.uncovered and !card.on_card_grid and card.type == card.CardType.FEATURE
	
func event_card_can_be_drawn(event, card):
	return event.pressed and not card.uncovered and card.type == card.CardType.EVENT
	
func debt_can_be_refactored(event, debt):
	var selected_cards_from_area = backlog.get_chosen_cards_from_area(debt.area)
	if selected_cards_from_area.size() > 0:
		label.text = ("You can only refactor in "+ debt.area + " if you have no cards selected from "+ debt.area)
	print(debt.area, selected_cards_from_area, debt.to_be_refectored)
	return event.pressed and 1 <= supply.available_storypoints() and not debt.to_be_refectored and selected_cards_from_area.size() == 0
	
func debt_can_be_unchoosen(event, debt):
	return event.pressed and debt.to_be_refectored
	
func execute_card_effect(card):
	var effects = card.effects
	for effect in effects:
		var effect_name = effect[0]
		var effect_value = effect[1]
		match effect_name:
			"add_storypoints":
				await supply.change_storypoints(effect_value)
			"add_technical_debt":
				await techical_debt_account.add_debt_effect(effect_value)
			"remove_technical_debt":
				await techical_debt_account.remove_debt_effect(effect_value)
			"bugs":
				await spawn_bug(effect_value)
			"features":
				for i in range(0, effect_value):
					var drawn_card = feature_deck.draw_card()
					await move_card_to_cardslot(drawn_card)
			"must_choose":
				await must_choose_card(card)
			"new_texture":
				await card.use_new_texture(effect_value)
			_:
				push_warning("Unknown Effect: %s" % effect_name)
	
func must_choose_card(card):
	card.cannot_be_unchosen = true
	move_card_to_cardslot(card)
	card.z_index = 2
	card.back_flip_card()
	await get_tree().create_timer(1.0).timeout
	card.choose_card()
	
	move_storypoints_to_card(card, card.storypoints + techical_debt_account.calculate_needed_storypoints(card.area))
	
func spawn_bug(effect_value):
	for i in range(0, effect_value):
		var card = bug_deck.draw_card()
		move_card_to_cardslot(card)
		await get_tree().create_timer(2.0).timeout

func raycast_check_for_object():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var candidate = result[0].collider.get_parent()
		if candidate:
			return candidate
	else:
		return null

func move_card_to_cardslot(card):
	var start_pos = card.global_position  # capture before reparenting
	var next_free_card_slot = backlog.get_next_free_card_slot()
	if next_free_card_slot:
		var end_pos = next_free_card_slot.global_position

		card.z_index = 3
		card.get_parent().remove_child(card)
		next_free_card_slot.add_child(card)
		card.scale = Vector2.ONE
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
	card.scale = Vector2.ONE
	card.z_index = 1
	card.global_position = start_pos

	var end_pos = pile.global_position
	var tween := get_tree().create_tween()
	tween.tween_property(card, "scale", Vector2(0.8, 0.8), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "global_position", end_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func move_storypoints_to_debt(debt):
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
		
func move_storypoints_to_card(card, needed_storypoints):
	var storypoints_in_supply = supply.storypoints_reference.get_children()
	storypoints_in_supply.sort_custom(func(a, b): return a.position.x < b.position.x)
	var selected_storypoints = storypoints_in_supply.slice(0, needed_storypoints)

	# Get card width from either Sprite2D or CollisionShape2D
	var card_width
	if card.has_node("CollisionShape2D"):
		var shape = card.get_node("CollisionShape2D").shape
		if shape is RectangleShape2D:
			card_width = shape.extents.x * 2 * card.get_node("CollisionShape2D").scale.x

	# Transfer storypoints to the card
	for sp in selected_storypoints:
		var start_pos = sp.global_position
		supply.storypoints_reference.remove_child(sp)
		card.storypoints_reference.add_child(sp)
		sp.scale = Vector2.ONE
		sp.global_position = start_pos

	# Get all storypoints currently on the card (old and new)
	var all_storypoints = card.storypoints_reference.get_children()
	var count = all_storypoints.size()
	var spacing = 40.0
	var total_width = (count - 1) * spacing
	var start_x = card.global_position.x - total_width / 2
	var y_pos = card.global_position.y

	# Reposition all storypoints centered on the card
	for i in range(count):
		var sp = all_storypoints[i]
		var target_x = start_x + i * spacing
		var target_pos = Vector2(target_x, y_pos)

		var tween = get_tree().create_tween()
		tween.tween_property(sp, "global_position", target_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func move_storypoints_to_supply(card_or_debt):
	var storypoints_on_card = card_or_debt.storypoints_reference.get_children()
		
	for sp in storypoints_on_card:
		var start_pos = sp.global_position
		var end_pos = sp.original_position
		card_or_debt.storypoints_reference.remove_child(sp)
		supply.storypoints_reference.add_child(sp)
		sp.global_position = start_pos
		
		var tween := get_tree().create_tween()
		tween.tween_property(sp, "global_position", end_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func create_button(text: String, position: Vector2, z_index) -> Button:
	var button = Button.new()
	button.text = text
	button.z_index = z_index
	button.position = position  # Only works with Node2D; use `rect_position` for Control-based UIs
	canvas_layer.add_child(button)
	return button
