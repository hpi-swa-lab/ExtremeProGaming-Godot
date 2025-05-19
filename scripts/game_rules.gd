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
#@onready var sp_button = $"../ChooseSPButton"
#@onready var debt_button = $"../ChooseDebtButton"
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
		
	await get_tree().create_timer(2.0).timeout
	for sp in supply.storypoints_reference.get_children():
		sp.self_destroy -= 1
		if sp.self_destroy <= 0:
			sp.queue_free()
		else:
			supply.STORYPOINTS -= 1
	for card in chosen_cards:
		execute_card_effect(card.effects)
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
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 0.5, 0.5) # fade in
	
func lighten_background():
	$"../DarkenedBackground".visible = false
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
				if not event_card_drawn_once and event_card_can_be_drawn(event, card):
					event_card_drawn_once = true
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
					move_storypoints_to_card(card, card.storypoints)
					choose_story_point_or_debt(card)
					
				elif card_can_be_unchoosen(event, card):
					card.choose_card()
					move_storypoints_to_supply(card)
					remove_technical_debt(card)

func remove_technical_debt(card):
	if card.storypoint_or_debt == "debt":
		var children = techical_debt_account.debt_reference.get_children()
		children[-1].queue_free()
	card.storypoint_or_debt = null

func choose_story_point_or_debt(card):
	await get_tree().create_timer(0.5).timeout
	darken_background()
	# instatiate storypoint
	var storypoint_scene = preload("res://scenes/storypoint.tscn")  
	var new_storypoint = storypoint_scene.instantiate()
	new_storypoint.global_position = Vector2(700, 600)
	new_storypoint.get_node("StorypointImage").scale = Vector2(0.05, 0.03)
	new_storypoint.z_index = 5
	add_child(new_storypoint)
	
	# instatiate debt
	var debt_scene = preload("res://scenes/technical_debt.tscn")  
	var new_debt = debt_scene.instantiate()
	new_debt.global_position = Vector2(1200, 600)
	new_debt.get_node("Sprite2D").scale = Vector2(0.25, 0.25)
	new_debt.z_index = 5
	add_child(new_debt)
	choose_sp_or_debt_label.visible = true
	
	var sp_button = create_button("Storypoints", Vector2(618, 791), canvas_layer, 5)
	sp_button.connect("button_down", func(): _on_choose_sp_button_down(card))
	var debt_button = create_button("Technical Debt", Vector2(1147, 791), canvas_layer, 5)
	debt_button.connect("button_down", func(): _on_choose_debt_button_down(card))
	
	
					
func card_can_be_choosen(event, card, needed_storypoints):
	return event.pressed and not card.uncovered and card.on_card_grid and card.chosen == false and needed_storypoints <= available_storypoints() and (card.type == card.CardType.FEATURE or card.type == card.CardType.BUG) 
	
func card_can_be_unchoosen(event, card):
	return event.pressed and not card.uncovered and card.on_card_grid and card.chosen and card.type == card.CardType.FEATURE
	
func feature_card_can_be_drawn(event, card):
	return event.pressed and not card.uncovered and !card.on_card_grid and card.type == card.CardType.FEATURE
	
func event_card_can_be_drawn(event, card):
	return event.pressed and not card.uncovered and card.type == card.CardType.EVENT
	
func execute_card_effect(effects):
	for effect in effects:
		var effect_name = effect[0]
		var effect_value = effect[1]
		match effect_name:
			"storypoints":
				supply.change_storypoints(effect_value)
			"technical_debt":
				change_debt(effect_value)
			"bugs":
				spawn_bug(effect_value)
			_:
				push_warning("Unknown Effect: %s" % effect_name)
		await get_tree().create_timer(2.0).timeout
	
func change_debt(effect_value):
	pass
	
func spawn_bug(effect_value):
	for i in range(0, effect_value):
		var card = bug_deck.draw_card()
		move_card_to_cardslot(card)
		await get_tree().create_timer(2.0).timeout

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

		card.z_index = 3
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

func blend_out_choosing_screen():
	lighten_background()
	choose_sp_or_debt_label.visible = false

	for child in get_children():
		child.queue_free()
	for child in canvas_layer.get_children():
		child.queue_free()
	
func _on_choose_sp_button_down(card) -> void:
	blend_out_choosing_screen()
	move_storypoints_to_card(card, 1)
	card.storypoint_or_debt = "storypoint"


func _on_choose_debt_button_down(card) -> void:
	blend_out_choosing_screen()
	techical_debt_account.spawn_debt("frontend")
	card.storypoint_or_debt = "debt"

func create_button(text: String, position: Vector2, parent: Node, z_index) -> Button:
	var button = Button.new()
	button.text = text
	button.z_index = z_index
	button.position = position  # Only works with Node2D; use `rect_position` for Control-based UIs
	parent.add_child(button)
	return button
