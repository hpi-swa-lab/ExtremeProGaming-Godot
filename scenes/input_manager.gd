extends Node2D
#
#signal left_mouse_button_clicked
#signal left_mouse_button_released
#
#const COLLISION_MASK_CARD = 1
#const COLLISION_MASK_DECK = 4
#
#var deck_reference
#
#func _ready() -> void:
	#deck_reference = $"../Deck"
	#
#func _input(event):
	#if event is InputEventMouseButton:
		#if event.pressed:
			#emit_signal("left_mouse_button_clicked")
			#raycast_at_curser()
#
#func raycast_at_curser():
	#var space_state = get_world_2d().direct_space_state
	#var parameters = PhysicsPointQueryParameters2D.new()
	#parameters.position = get_global_mouse_position()
	#parameters.collide_with_areas = true
	#var result = space_state.intersect_point(parameters)
	#if result.size() > 0:
		#var result_collision_mask = result[0].collider.collision_mask
		#if result_collision_mask == COLLISION_MASK_DECK:
			## Deck clicked
			#deck_reference.draw_card()
