extends Node2D

@export var follower_scene: PackedScene

var card_being_dragged


#func _process(delta: float) -> void:
	#if card_being_dragged:
		#var mouse_pos = get_global_mouse_position()
		#card_being_dragged.position = mouse_pos
		#
#func _ready() -> void:
	#$"../InputManager".connect("left_mouse_button_released", on_left_click_released)
	

#func _input(event):
	#if event is InputEventMouseButton:
		#var card = raycast_check_for_card()
		#if card and event.button_index == MOUSE_BUTTON_LEFT:
			#if event.pressed:
				#start_drag(card)
			#else:
				#finish_drag()
#
		#if card and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			#var card_image = card.get_node("CardImage")
			#var card_flip = card.get_node("CardFlip")
			#if card_image.z_index == -1:
				#card_flip.play("card_flip")
			#elif card_image.z_index == 0:
				#card_flip.play_backwards("card_flip")
				
#func start_drag(card):
	#card_being_dragged = card
	#
#func finish_drag():
	#var card_slot_found = raycast_check_for_card_slot()
	#print(card_slot_found)
	#if card_slot_found and not card_slot_found.card_in_slot:
		## card was dropped in empty slot
		#card_being_dragged.position = card_slot_found.position
		#card_slot_found.card_in_slot = true
	#card_being_dragged = null
	
#func raycast_check_for_card_slot():
	#var space_state = get_world_2d().direct_space_state
	#var parameters = PhysicsPointQueryParameters2D.new()
	#parameters.position = get_global_mouse_position()
	#parameters.collide_with_areas = true
	#parameters.collision_mask = 2
	#var result = space_state.intersect_point(parameters)
	#if result.size() > 0:
		#return result[0].collider.get_parent()
	#else:
		#return null
#
#
#func raycast_check_for_card():
	#var space_state = get_world_2d().direct_space_state
	#var parameters = PhysicsPointQueryParameters2D.new()
	#parameters.position = get_global_mouse_position()
	#parameters.collide_with_areas = true
	#parameters.collision_mask = 1
	#var result = space_state.intersect_point(parameters)
	#if result.size() > 0:
		#return result[0].collider.get_parent()
	#else:
		#return null
		#
