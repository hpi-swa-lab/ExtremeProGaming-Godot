extends Node2D

@onready var feature_deck = $"../FeatureDeck"
@onready var event_deck = $"../EventDeck"
@onready var bug_deck = $"../BugDeck"
@onready var backlog = $"../Backlog"
@onready var techical_debt_account = $"../TechnicalDebtAccount"
@onready var supply = $"../Supply"
@onready var label = $"../EffectDisplay/GameNotifications"
@onready var discard_pile = $"../DiscardPile"
@onready var event_discard_pile = $"../EventDiscardPile"
@onready var canvas_layer = $"../CanvasLayer"
@onready var game_stats =$"../GameStats"
@onready var allow_refactoring = true
@onready var reward_after_goal_is_reached = false
@onready var iteration = 1
@onready var current_phase
var event_card_drawn_once = false

const BUTTON_SCENE_PATH = "res://scenes/button.tscn"

enum Phase {
	DRAW_EVENT,
	DRAW_FEATURE,
	PLAN,
	END
}

func _ready():
	await feature_deck.cards_ready
	await bug_deck.cards_ready
	draw_start_cards()
	prepare_iteration()
	
func draw_start_cards():
	var start_cards = feature_deck.START_CARDS
	start_cards.append_array(bug_deck.START_CARDS)
	for start_card in start_cards:
		start_card.z_index = 1
		move_card_to_cardslot(start_card)
	
func prepare_iteration():
	allow_refactoring = true
	event_card_drawn_once = false
	event_deck.get_node("SelectionBorder").visible = true
	current_phase = Phase.DRAW_EVENT
	label.text = ("DRAW_EVENT_DESC")
	if reward_after_goal_is_reached and iteration == 3 and discard_pile.get_all_features() >= 4:
		await supply.add_storypoints_effect([2, 10000])
		
func plan_iteration():
	highlight_elements_for_plan_phase(true)
	current_phase = Phase.PLAN
	label.text = ("GAME_HINT")
	
func _on_read_event_button_down(drawn_card) -> void:
	lighten_background()
	drawn_card.z_index = 4
	move_card_to_discard_pile(drawn_card, event_discard_pile)
	for child in canvas_layer.get_children():
		child.queue_free()
	await get_tree().create_timer(1.0).timeout
	label.text = await generate_effect_display(drawn_card.effects)
	await execute_card_effect(drawn_card)
	await get_tree().create_timer(4.0).timeout
	drawn_card.z_index = -2
	event_deck.get_node("SelectionBorder").visible = false
	feature_deck.get_node("SelectionBorder").visible = true
	current_phase = Phase.DRAW_FEATURE
	label.text = ("DRAW_FEATURE_RULE")
	
func _on_start_iteration_button_down() -> void:
	if iteration >= 9:
		get_tree().change_scene_to_file("res://scenes/game_won_screen.tscn")
		return
	for child in canvas_layer.get_children():
		child.queue_free()
		
	lighten_background()
	var chosen_cards = backlog.get_chosen_cards()
	for card in chosen_cards:
		var card_slot = card.get_parent().get_parent()
		card_slot.is_card_in_slot = false
		card.choose_card() # we execute this to make the card unusable in that state
		move_card_to_discard_pile(card, discard_pile)
	techical_debt_account.remove_refactored_debt()
		
	await get_tree().create_timer(2.0).timeout
	supply.calculate_storypoints_for_iteration()
	
	await get_tree().create_timer(1.0).timeout
	var effects = []
	for card in chosen_cards:
		for effect in card.effects:
			effects.append(effect)
	label.text = await generate_effect_display(effects)
	for card in chosen_cards:
		if card.cannot_be_unchosen == false:
			await execute_card_effect(card)
	await get_tree().create_timer(4.0).timeout
	techical_debt_account.calculate_and_add_technical_debt_after_iteration(chosen_cards)
	iteration += 1
	prepare_iteration()
	
		
	
func _on_end_iteration_button_down() -> void:
	highlight_elements_for_plan_phase(false)
	current_phase = Phase.END
	var chosen_cards = backlog.get_chosen_cards()
	var chosen_debt = techical_debt_account.get_all_debt_selected_for_refactoring()
	for card in backlog.get_all_cards_in_backlog():
		card.cannot_be_choosen = false
	for card in chosen_cards:
		card.flip_card()
		move_storypoints_to_supply(card)
	for debt in chosen_debt:
		move_storypoints_to_supply(debt)

	darken_background()
	move_cards_to_front(chosen_cards, chosen_debt)
	
	var start_iteration_button = create_button("START_NEW_ITERATION", Vector2(800.0, 800.0), 5)
	start_iteration_button.connect("button_down", func(): _on_start_iteration_button_down())
	
func _process(delta):
	update_game_stats()
	if backlog.no_cards_chosen() and techical_debt_account.no_debt_selected() == 0:
		$"../EndIterationButton".disabled = true
	else:
		$"../EndIterationButton".disabled = false
		
	if backlog.get_all_cards_in_backlog().size() >= 9:
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
		
	
func darken_background():
	$"../DarkenedBackground".visible = true
	var tween = create_tween()
	tween.tween_property($"../ColorRect", "modulate:a", 0.5, 0.5)
	
func lighten_background():
	$"../DarkenedBackground".visible = false
	var tween = create_tween()
	tween.tween_property($"../ColorRect", "modulate:a", 0.5, 0.5)
	
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
		var debt_y_position = screen_size.y * 0.2  # Position debt at 20% from top
		
		for i in range(debt_count):
			var debt = chosen_debt[i]
			debt.z_index = 8
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
					
					var event_button = create_button("UNDERSTOOD_EVENT", Vector2(800.0, 800.0), 5)
					event_button.connect("button_down", func(): _on_read_event_button_down(drawn_card))
			Phase.DRAW_FEATURE:
				if card and feature_card_can_be_drawn(event, card):
					var drawn_card = feature_deck.draw_card()
					move_card_to_cardslot(drawn_card)
					plan_iteration()

			Phase.PLAN:
				highlight_elements_for_plan_phase(true)
				if card and (card.type == card.CardType.FEATURE or card.type == card.CardType.BUG):
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
				elif debt and debt_can_be_refactored(event, debt):
					debt.to_be_refectored = true
					move_storypoints_to_debt(debt)
				elif debt and debt_can_be_unchoosen(event, debt):
					debt.to_be_refectored = false
					move_storypoints_to_supply(debt)
					
	
func card_can_be_choosen(event, card, needed_storypoints):
	if techical_debt_account.get_currently_refactored_debt_for_area(card.area) != 0:
		label.text = ("REFACTOR_HINT_CARD")
	return event.pressed and not card.uncovered and card.on_card_grid and card.chosen == false and needed_storypoints <= supply.available_storypoints() and techical_debt_account.get_currently_refactored_debt_for_area(card.area) == 0 and card.cannot_be_choosen == false 
	
func card_can_be_unchoosen(event, card):
	return event.pressed and not card.uncovered and card.on_card_grid and card.chosen and card.cannot_be_unchosen == false
	
func feature_card_can_be_drawn(event, card):
	return event.pressed and not card.uncovered and !card.on_card_grid and card.type == card.CardType.FEATURE and feature_deck.CARDS_IN_DECK != []
	
func event_card_can_be_drawn(event, card):
	return event.pressed and not card.uncovered and card.type == card.CardType.EVENT
	
func debt_can_be_refactored(event, debt):
	var selected_cards_from_area = backlog.get_chosen_cards_from_area(debt.area)
	if selected_cards_from_area.size() > 0:
		label.text = ("REFACTOR_HINT_DEBT")
	return event.pressed and 1 <= supply.available_storypoints() and not debt.to_be_refectored and selected_cards_from_area.size() == 0 and allow_refactoring
	
func debt_can_be_unchoosen(event, debt):
	return event.pressed and debt.to_be_refectored
	
func execute_card_effect(card):
	var effects = card.effects
	for effect in effects:
		await get_tree().create_timer(0.2).timeout
		var effect_name = effect[0]
		var effect_value = effect[1]
		match effect_name:
			"add_storypoints":
				await supply.add_storypoints_effect(effect_value)
			"remove_storypoints":
				await supply.remove_storypoints_effect(effect_value)
			"half_storypoints":
				await supply.half_storypoints_effect(effect_value)
			"add_technical_debt":
				techical_debt_account.add_debt_effect(effect_value)
			"remove_technical_debt":
				techical_debt_account.remove_debt_effect(effect_value)
			"remove_cheapest_feature":
				var cards = backlog.get_cheapest_feature_effect(effect_value)
				for cheapest_card in cards:
					cheapest_card.get_parent().get_parent().is_card_in_slot = false
					await move_card_to_discard_pile(cheapest_card, discard_pile)
			"if_frontend_debt_too_big":
				if techical_debt_account.get_current_debt_from_area("frontend") >= effect_value:
					await move_card_to_backlog(card)
			"goal":
				reward_after_goal_is_reached = true
			"bugs":
				await spawn_bug(effect_value)
			"features":
				for i in range(0, effect_value):
					var drawn_card = feature_deck.draw_card()
					drawn_card.z_index = 5
					await move_card_to_cardslot(drawn_card)
			"cheap_feature_is_implemented":
				var possible_card = backlog.get_card_with_storypoints(effect_value)
				if possible_card != null:
					move_card_to_discard_pile(possible_card, discard_pile)
			"back_to_backlog":
				await move_card_to_backlog(card)
			"must_choose":
				await must_choose_card(card)
			"cannot_be_choosen":
				card.cannot_be_choosen = true
			"new_values":
				await card.use_new_texture(effect_value)
			"prohibit_refactoring":
				allow_refactoring = false
			_:
				push_warning("Unknown Effect: %s" % effect_name)
				
func generate_effect_display(effects):
	var text = tr("EFFECT_DISPLAY_HEADER") + "\n"
	for effect in effects:
		await get_tree().create_timer(0.2).timeout
		var effect_name = effect[0]
		var effect_value = effect[1]
		match effect_name:
			"if_frontend_debt_too_big":
				text += "• " + tr("FRONTEND_DEBT_BIG") + "\n"
			"back_to_backlog":
				text += "• " + tr("BACK_TO_BACKLOG") + "\n"
			"add_storypoints":
				text += "• " + tr("ADD_STORYPOINTS") + "\n"
			"remove_storypoints":
				text += "• " + tr("REMOVE_STORYPOINTS") + "\n"
			"half_storypoints":
				text += "• " + tr("HALF_STORYPOINTS") + "\n"
			"add_technical_debt":
				text += "• " + tr("ADD_TECHNICAL_DEBT") + "\n"
			"remove_technical_debt":
				text += "• " + tr("REMOVE_TECHNICAL_DEBT") + "\n"
			"remove_cheapest_feature":
				text += "• " + tr("REMOVE_CHEAPEST_FEATURE") + "\n"
			"cheap_feature_is_implemented":
				text += "• " + tr("IMPLEMENT_CHEAP_FEATURE") + "\n"
			"cannot_be_choosen":
				text += "• " + tr("CANNOT_BE_CHOSEN") + "\n"
			"goal":
				text += "• " + tr("REACH_GOAL") + "\n"
			"bugs":
				text += "• " + tr("DRAW_BUG") + "\n"
			"features":
				text += "• " + tr("DRAW_FEATURE") + "\n"
			"must_choose":
				text += "• " + tr("MUST_CHOOSE") + "\n"
			"new_values":
				text += "• " + tr("NEW_VALUES") + "\n"
			"prohibit_refactoring":
				text += "• " + tr("NO_REFACTOR") + "\n"
			_:
				push_warning("Unknown Effect: %s" % effect_name)
	return text
				
	
func move_card_to_backlog(card):
	move_card_to_cardslot(card)
	card.z_index = 2
	card.back_flip_card()
	await get_tree().create_timer(1.0).timeout
	
	
func must_choose_card(card):
	card.cannot_be_unchosen = true
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
		next_free_card_slot.card_reference.add_child(card)
		card.scale = Vector2.ONE
		card.global_position = start_pos

		var tween := get_tree().create_tween()
		tween.tween_property(card, "global_position", end_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		next_free_card_slot.is_card_in_slot = true
		next_free_card_slot.card_reference.add_child(card)
		card.on_card_grid = true
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
		sp.z_index = 5
		var start_pos = sp.global_position
		var end_pos = sp.original_position
		card_or_debt.storypoints_reference.remove_child(sp)
		supply.storypoints_reference.add_child(sp)
		sp.global_position = start_pos
		
		var tween := get_tree().create_tween()
		tween.tween_property(sp, "global_position", end_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func create_button(text: String, position: Vector2, z_index) -> Button:
	var button_scene = preload(BUTTON_SCENE_PATH)
	var button = button_scene.instantiate()
	button.text = text
	button.size.x = 320
	button.size.y = 100
	button.add_theme_font_size_override("font_size", 40)
	button.z_index = z_index
	button.position = position
	canvas_layer.add_child(button)
	return button
	
func highlight_elements_for_plan_phase(state):
	var cards_in_backlog = backlog.get_all_cards_in_backlog()
	for card in cards_in_backlog:
		card.get_node("SelectionBorder").visible = state
	feature_deck.get_node("SelectionBorder").visible = state
	
	if allow_refactoring:
		var current_debt = techical_debt_account.get_all_debt()
		for debt in current_debt:
			debt.get_node("SelectionBorder").visible = state
	


func update_game_stats():
	var finished_features = 0
	var frontend_features = 0
	var backend_features = 0
	var finished_bugs = 0
	var frontend_bugs = 0
	var backend_bugs = 0
	for card in discard_pile.card_reference.get_children():
		if card.type == card.CardType.FEATURE:
			finished_features +=1
			if card.area == "frontend":
				frontend_features += 1
			if card.area == "backend":
				backend_features += 1
		if card.type == card.CardType.BUG:
			finished_bugs +=1
			if card.area == "frontend":
				frontend_bugs += 1
			if card.area == "backend":
				backend_bugs += 1
	
	game_stats.iteration.text = "%d" % [iteration]
	game_stats.team.text = "%d" % [supply.available_storypoints()]
	game_stats.featuresfrontend.text = "%d" % [frontend_features]
	game_stats.featuresbackend.text = "%d" % [backend_features]
	game_stats.bugsbackend.text = "%d" % [backend_bugs]
	game_stats.bugsfrontend.text = "%d" % [frontend_bugs]
	
	
	
