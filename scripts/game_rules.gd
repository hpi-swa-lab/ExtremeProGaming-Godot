extends Node2D

@onready var deck = $"../Deck"
@onready var backlog = $"../Backlog"
@onready var supply = $"../Supply"
@onready var label = $"../GameNotifications"

func _ready():
	label.text = "[center][font_size=24]Draw cards![/font_size][/center]"


func _input(event):
	if event is InputEventMouseButton:
		var card = raycast_check_for_card()
		if card and event.button_index == MOUSE_BUTTON_LEFT:
			var needed_storypoints = card.storypoints
			if event.pressed and not card.uncovered:
				if card.on_card_grid and !card.chosen and needed_storypoints <= available_storypoints():
					card.choose_card()
					move_storypoints_to_card(card)
				
				elif card.on_card_grid and card.chosen:
					card.choose_card()
					move_storypoints_to_supply(card)
				elif !card.on_card_grid:
					var drawn_card = deck.draw_card()
					move_card_to_cardslot(drawn_card)
					
					var card_container = backlog.get_card_container()
					if drawn_card.get_parent():
						drawn_card.get_parent().remove_child(drawn_card)
					card_container.add_child(drawn_card)


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

		# Optionally reparent first, *then* set global position
		card.get_parent().remove_child(card)
		var parent = get_tree().get_root()  # or another suitable container
		parent.add_child(card)
		card.global_position = start_pos

		var tween := get_tree().create_tween()
		tween.tween_property(card, "global_position", end_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		next_free_card_slot.card_in_slot = true
		card.on_card_grid = true
		return card
	else:
		return null

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
