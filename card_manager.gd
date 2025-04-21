extends Node2D

@export var follower_scene: PackedScene

var card_being_dragged

func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = mouse_pos
	

func _input(event):
	if event is InputEventMouseButton:
		var card = raycast_check_for_card()
		if card and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				card_being_dragged = card
			else:
				card_being_dragged = null
				
		if card and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if $Card/CardImage.z_index == -1:
				get_node("Card/CardFlip").play("card_flip")
			if $Card/CardImage.z_index == 0:
				get_node("Card/CardFlip").play_backwards("card_flip")

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	else:
		return null
