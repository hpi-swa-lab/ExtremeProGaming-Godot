extends Node2D

@onready var feature_deck = $"../FeatureDeck"
@onready var event_deck = $"../EventDeck"
@onready var bug_deck = $"../BugDeck"
@onready var backlog = $"../Backlog"
@onready var techical_debt_account = $"../TechnicalDebtAccount"
@onready var supply = $"../Supply"
@onready var discard_pile = $"../DiscardPile"
@onready var event_discard_pile = $"../EventDiscardPile"
@onready var player_hand = $"../PlayerHand"
@onready var canvas_layer = $"../CanvasLayer"
@onready var effect_display = $"../EffectDisplay"
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
		player_hand.move_card_to_cardslot(backlog, start_card)
	
func prepare_iteration():
	allow_refactoring = true
	event_card_drawn_once = false
	event_deck.get_node("SelectionBorder").visible = true
	current_phase = Phase.DRAW_EVENT
	effect_display.generate_draw_event_rule()
	if reward_after_goal_is_reached and iteration == 3 and discard_pile.get_all_features() >= 4:
		await supply.add_storypoints_effect([2, 10000])
		
func plan_iteration():
	highlight_elements_for_plan_phase(true)
	current_phase = Phase.PLAN
	effect_display.generate_iteration_rules()
	
	
func _on_read_event_button_down(drawn_card) -> void:
	lighten_background()
	drawn_card.z_index = 4
	player_hand.move_card_to_discard_pile(drawn_card, event_discard_pile)
	for child in canvas_layer.get_children():
		child.queue_free()
	await get_tree().create_timer(1.0).timeout
	effect_display.generate_effects_list(drawn_card.effects)
	await execute_card_effect(drawn_card)
	await get_tree().create_timer(4.0).timeout
	drawn_card.z_index = -2
	event_deck.get_node("SelectionBorder").visible = false
	feature_deck.get_node("SelectionBorder").visible = true
	current_phase = Phase.DRAW_FEATURE
	effect_display.generate_draw_feature_rule()
	
	
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
		player_hand.move_card_to_discard_pile(card, discard_pile)
	techical_debt_account.remove_refactored_debt()
		
	await get_tree().create_timer(2.0).timeout
	supply.calculate_storypoints_for_iteration()
	
	await get_tree().create_timer(1.0).timeout
	var effects = []
	for card in chosen_cards:
		for effect in card.effects:
			effects.append(effect)
	effect_display.generate_effects_list(effects)
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
		player_hand.move_storypoints_to_supply(supply, card)
	for debt in chosen_debt:
		player_hand.move_storypoints_to_supply(supply, debt)

	darken_background()
	player_hand.move_cards_to_front(chosen_cards, chosen_debt)
	
	var start_iteration_button = create_button("START_NEW_ITERATION", Vector2(800.0, 800.0), 5)
	start_iteration_button.connect("button_down", func(): _on_start_iteration_button_down())
	
func _process(delta):
	game_stats.update_game_stats(iteration, 
								supply.available_storypoints(), 
								discard_pile.get_features_in_area("frontend"), 
								discard_pile.get_features_in_area("backend"), 
								discard_pile.get_bugs_in_area("frontend"), 
								discard_pile.get_bugs_in_area("backend"))
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
					player_hand.move_cards_to_front([drawn_card], null)
					await get_tree().create_timer(2.0).timeout
					drawn_card.flip_card()
					
					var event_button = create_button("UNDERSTOOD_EVENT", Vector2(800.0, 800.0), 5)
					event_button.connect("button_down", func(): _on_read_event_button_down(drawn_card))
			Phase.DRAW_FEATURE:
				if card and feature_card_can_be_drawn(event, card):
					var drawn_card = feature_deck.draw_card()
					player_hand.move_card_to_cardslot(backlog, drawn_card)
					plan_iteration()

			Phase.PLAN:
				highlight_elements_for_plan_phase(true)
				if card and (card.type == card.CardType.FEATURE or card.type == card.CardType.BUG):
					var needed_storypoints = card.storypoints + techical_debt_account.calculate_needed_storypoints(card.area)
					if card and feature_card_can_be_drawn(event, card):
						var drawn_card = feature_deck.draw_card()
						player_hand.move_card_to_cardslot(backlog, drawn_card)
					elif card and await card_can_be_choosen(event, card, needed_storypoints):
						card.choose_card()
						player_hand.move_storypoints_to_card(supply, card, needed_storypoints)
					elif card and card_can_be_unchoosen(event, card):
						card.choose_card()
						player_hand.move_storypoints_to_supply(supply, card)
				elif debt and await debt_can_be_refactored(event, debt):
					debt.to_be_refectored = true
					player_hand.move_storypoints_to_debt(supply, debt)
				elif debt and debt_can_be_unchoosen(event, debt):
					debt.to_be_refectored = false
					player_hand.move_storypoints_to_supply(supply, debt)
					
	
func card_can_be_choosen(event, card, needed_storypoints):
	if techical_debt_account.get_currently_refactored_debt_for_area(card.area) != 0:
		effect_display.generate_refactor_rule()
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
		effect_display.generate_refactor_rule()
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
					await player_hand.move_card_to_discard_pile(cheapest_card, discard_pile)
			"if_frontend_debt_too_big":
				if techical_debt_account.get_current_debt_from_area("frontend") >= effect_value:
					await player_hand.move_card_to_backlog(backlog, card)
			"goal":
				reward_after_goal_is_reached = true
			"bugs":
				await spawn_bug(effect_value)
			"features":
				for i in range(0, effect_value):
					var drawn_card = feature_deck.draw_card()
					drawn_card.z_index = 5
					await player_hand.move_card_to_cardslot(backlog, drawn_card)
			"cheap_feature_is_implemented":
				var possible_card = backlog.get_card_with_storypoints(effect_value)
				if possible_card != null:
					player_hand.move_card_to_discard_pile(possible_card, discard_pile)
			"back_to_backlog":
				await player_hand.move_card_to_backlog(backlog, card)
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

func must_choose_card(card):
	card.cannot_be_unchosen = true
	card.choose_card()
	player_hand.move_storypoints_to_card(supply, card, card.storypoints + techical_debt_account.calculate_needed_storypoints(card.area))
	
func spawn_bug(effect_value):
	for i in range(0, effect_value):
		var card = bug_deck.draw_card()
		player_hand.move_card_to_cardslot(backlog, card)
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
